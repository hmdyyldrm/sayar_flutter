// lib/screens/gunluk_hedefler_screen.dart
import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import 'zikirmatik_screen.dart';

class GunlukHedeflerScreen extends StatefulWidget {
  const GunlukHedeflerScreen({super.key});

  @override
  State<GunlukHedeflerScreen> createState() => _GunlukHedeflerScreenState();
}

class _GunlukHedeflerScreenState extends State<GunlukHedeflerScreen> {
  List<String> metins = [];
  List<int> hedefs = [];
  List<int> sayacs = [];
  int yuzde = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await PreferencesService.loadDailyGoals();
    setState(() {
      metins = List<String>.from(data['metins']);
      hedefs = List<int>.from(data['hedefs']);
      sayacs = List<int>.from(data['sayacs']);
      yuzde = data['yuzde'] as int;
    });
  }

  Future<void> _saveAll() async {
    await PreferencesService.saveDailyGoals(metins: metins, hedefs: hedefs, sayacs: sayacs, yuzde: yuzde);
  }

  void _openGoal(int index) {
    // push Zikirmatik with the goal's data and goalIndex so changes save back
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ZikirmatikScreen(
          title: metins[index],
          initialTarget: hedefs[index],
          initialCount: sayacs[index],
          goalIndex: index,
        ),
      ),
    ).then((_) async {
      // on return refresh from prefs to keep consistent with other edits
      await _load();
    });
  }

  void _incrementLocal(int index) {
    if (sayacs[index] < hedefs[index]) {
      setState(() => sayacs[index]++);
      _calculate();
      _saveAll();
    }
  }

  void _calculate() {
    final toplamHedef = hedefs.fold(0, (a, b) => a + b);
    final toplamSayac = sayacs.fold(0, (a, b) => a + b);
    yuzde = toplamHedef > 0 ? ((toplamSayac / toplamHedef) * 100).round() : 0;
  }

  void _addGoalDialog() {
    final metinCtrl = TextEditingController();
    final hedefCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Yeni Hedef'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: metinCtrl, decoration: const InputDecoration(labelText: 'Hedef metni')),
          TextField(controller: hedefCtrl, decoration: const InputDecoration(labelText: 'Hedef sayı'), keyboardType: TextInputType.number),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () async {
              if (metinCtrl.text.isNotEmpty && int.tryParse(hedefCtrl.text) != null) {
                setState(() {
                  metins.add(metinCtrl.text);
                  hedefs.add(int.parse(hedefCtrl.text));
                  sayacs.add(0);
                  _calculate();
                });
                await _saveAll();
                Navigator.pop(context);
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _editGoal(int index) {
    final metinCtrl = TextEditingController(text: metins[index]);
    final hedefCtrl = TextEditingController(text: hedefs[index].toString());
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
              setState(() {
                metins[index] = metinCtrl.text;
                hedefs[index] = int.tryParse(hedefCtrl.text) ?? hedefs[index];
              });
              await _saveAll();
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _deleteGoal(int index) async {
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
      setState(() {
        metins.removeAt(index);
        hedefs.removeAt(index);
        sayacs.removeAt(index);
        _calculate();
      });
      await _saveAll();
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
      body: metins.isEmpty
          ? const Center(child: Text('Henüz hedef yok'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: metins.length,
              itemBuilder: (context, i) {
                final done = sayacs[i] >= hedefs[i];
                return Card(
                  color: done ? Colors.green.shade50 : null,
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    title: Text(metins[i], style: TextStyle(fontWeight: done ? FontWeight.bold : FontWeight.normal)),
                    subtitle: Text('Hedef: ${hedefs[i]} • Kalan: ${ (hedefs[i] - sayacs[i]).clamp(0, hedefs[i]) }'),
                    onTap: () => _openGoal(i),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _editGoal(i)),
                      IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _deleteGoal(i)),
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
