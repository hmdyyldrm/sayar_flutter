import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import 'zikirmatik_screen.dart';

class GunlukHedeflerScreen extends StatefulWidget {
  const GunlukHedeflerScreen({super.key});

  @override
  State<GunlukHedeflerScreen> createState() => _GunlukHedeflerScreenState();
}

class _GunlukHedeflerScreenState extends State<GunlukHedeflerScreen> {
  final db = DatabaseHelper.instance;
  List<Map<String, dynamic>> hedefler = [];
  int yuzde = 0;

  // Helper: dynamic (int/String/null) → safe int
  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _loadFromDb();
  }

  /// 🔹 Tüm verileri SQLite veritabanından yükle
  Future<void> _loadFromDb() async {
    final data = await db.getAllZikirler();
    if (data.isNotEmpty) {
      setState(() {
        hedefler = data;
        _calculate();
      });
      return;
    }

    // Eğer DB boşsa, eski uygulamanın SharedPreferences içinde sakladığı
    // "günlük hedefler" verisi olabilir. Bu durumda prefs'ten oku ve DB'ye
    // geçir (migration). Böylece eski veriler yeni app'te görünür.
    final migrated = await _tryMigrateFromPrefsToDb();
    if (migrated) {
      final reloaded = await db.getAllZikirler();
      setState(() {
        hedefler = reloaded;
        _calculate();
      });
    } else {
      setState(() {
        hedefler = [];
        yuzde = 0;
      });
    }
  }

  /// Legacy prefs -> DB migration.
  /// Returns true if any goals were migrated.
  Future<bool> _tryMigrateFromPrefsToDb() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 1) Preferred legacy format: string lists stored under keys 'metins','hedefs','sayacs'
      final metinsList = prefs.getStringList('metins');
      final hedefsList = prefs.getStringList('hedefs');
      final sayacsList = prefs.getStringList('sayacs');
      if (metinsList != null && metinsList.isNotEmpty) {
        final count = metinsList.length;
        for (var i = 0; i < count; i++) {
          final baslik = metinsList[i];
          final hedef = (hedefsList != null && i < hedefsList.length) ? hedefsList[i] : '0';
          final sayac = (sayacsList != null && i < sayacsList.length) ? sayacsList[i] : '0';
          await db.insertZikir({
            'baslik': baslik,
            'zikir': baslik,
            'foto': '',
            'hedef': hedef.toString(),
            'sayac': sayac.toString(),
            'bugun_sayac': '0',
            'toplam': '0',
            'baslangic_tarih': DateTime.now().toString(),
            'guncelleme_tarih': DateTime.now().toString(),
            'gecmis': '',
            'bildirim_saati': '',
          });
        }
        return true;
      }

      // 2) Fallback: per-index keys like metin0, hedef0, sayac0
      final keys = prefs.getKeys();
      final RegExp r = RegExp(r'^(metin|hedef|sayac)(\d+)\$');
      final Map<int, String> metins = {};
      final Map<int, String> hedefs = {};
      final Map<int, String> sayacs = {};
      for (final k in keys) {
        final m = r.firstMatch(k);
        if (m != null) {
          final base = m.group(1)!;
          final idx = int.tryParse(m.group(2)!) ?? 0;
          final v = prefs.getString(k) ?? prefs.getInt(k)?.toString() ?? '';
          if (base == 'metin') metins[idx] = v;
          if (base == 'hedef') hedefs[idx] = v;
          if (base == 'sayac') sayacs[idx] = v;
        }
      }
      if (metins.isNotEmpty) {
        final maxIndex = metins.keys.reduce((a, b) => a > b ? a : b);
        for (var i = 0; i <= maxIndex; i++) {
          final baslik = metins[i] ?? '';
          final hedef = hedefs[i] ?? '0';
          final sayac = sayacs[i] ?? '0';
          // skip empty basliks
          if (baslik.isEmpty) continue;
          await db.insertZikir({
            'baslik': baslik,
            'zikir': baslik,
            'foto': '',
            'hedef': hedef.toString(),
            'sayac': sayac.toString(),
            'bugun_sayac': '0',
            'toplam': '0',
            'baslangic_tarih': DateTime.now().toString(),
            'guncelleme_tarih': DateTime.now().toString(),
            'gecmis': '',
            'bildirim_saati': '',
          });
        }
        return true;
      }

      return false;
    } catch (e) {
      print('⚠️ prefs->db migration hata: $e');
      return false;
    }
  }

  /// 🔹 Yeni kayıt ekle veya mevcut kaydı güncelle
  Future<void> _save(Map<String, dynamic> row, {int? id}) async {
    if (id == null) {
      await db.insertZikir(row);
    } else {
      await db.updateZikir(id, row);
    }
    await _loadFromDb();
  }

  /// 🔹 Yüzde hesapla
  void _calculate() {
    if (hedefler.isEmpty) {
      yuzde = 0;
      return;
    }
  final toplamHedef = hedefler.fold<int>(0, (a, b) => a + _toInt(b['hedef']));
  final toplamSayac = hedefler.fold<int>(0, (a, b) => a + _toInt(b['sayac']));
    yuzde = toplamHedef > 0 ? ((toplamSayac / toplamHedef) * 100).round() : 0;
  }

  /// 🔹 Zikirmatik sayfasına yönlendir
  void _openGoal(Map<String, dynamic> hedef) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ZikirmatikScreen(
          title: hedef['baslik']?.toString() ?? '',
          initialTarget: _toInt(hedef['hedef']),
          initialCount: _toInt(hedef['sayac']),
          zikirId: _toInt(hedef['id']),
        ),
      ),
    ).then((_) => _loadFromDb());
  }

  /// 🔹 Yeni hedef ekleme
  void _addGoalDialog() {
    final metinCtrl = TextEditingController();
    final hedefCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Yeni Hedef'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: metinCtrl, decoration: const InputDecoration(labelText: 'Hedef metni')),
            TextField(controller: hedefCtrl, decoration: const InputDecoration(labelText: 'Hedef sayı'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () async {
              if (metinCtrl.text.isNotEmpty && int.tryParse(hedefCtrl.text) != null) {
                await _save({
                  'baslik': metinCtrl.text,
                  'zikir': metinCtrl.text,
                  'foto': '',
                  'hedef': hedefCtrl.text,
                  'sayac': '0',
                  'bugun_sayac': '0',
                  'toplam': '0',
                  'baslangic_tarih': DateTime.now().toString(),
                  'guncelleme_tarih': DateTime.now().toString(),
                  'gecmis': '',
                  'bildirim_saati': '',
                });
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  /// 🔹 Hedef düzenleme
  void _editGoal(Map<String, dynamic> hedef) {
  final metinCtrl = TextEditingController(text: hedef['baslik']?.toString() ?? '');
  final hedefCtrl = TextEditingController(text: hedef['hedef']?.toString() ?? '0');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Düzenle'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: metinCtrl, decoration: const InputDecoration(labelText: 'Metin')),
          TextField(controller: hedefCtrl, decoration: const InputDecoration(labelText: 'Hedef'), keyboardType: TextInputType.number),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () async {
                await _save({
                ...hedef,
                'baslik': metinCtrl.text,
                'hedef': hedefCtrl.text,
              }, id: _toInt(hedef['id']));
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  /// 🔹 Hedef silme
  void _deleteGoal(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sil'),
        content: const Text('Bu hedefi silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hayır')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Evet')),
        ],
      ),
    );
    if (ok == true) {
      await db.deleteZikir(id);
      await _loadFromDb();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Günlük Hedefler'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addGoalDialog),
        ],
      ),
      body: hedefler.isEmpty
          ? const Center(child: Text('Henüz hedef yok'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: hedefler.length,
              itemBuilder: (context, i) {
                final hedef = hedefler[i];
                final done = int.tryParse(hedef['sayac'] ?? '0')! >= int.tryParse(hedef['hedef'] ?? '0')!;
                return Card(
                  color: done ? Colors.green.shade50 : null,
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    title: Text(hedef['baslik'], style: TextStyle(fontWeight: done ? FontWeight.bold : FontWeight.normal)),
                    subtitle: Text('Hedef: ${hedef['hedef']} • Kalan: ${(int.tryParse(hedef['hedef'])! - int.tryParse(hedef['sayac'])!).clamp(0, int.tryParse(hedef['hedef'])!)}'),
                    onTap: () => _openGoal(hedef),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _editGoal(hedef)),
                      IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _deleteGoal(hedef['id'])),
                    ]),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text('Tamamlanan hedeflerin durumu: %$yuzde', textAlign: TextAlign.center),
      ),
    );
  }
}
