import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

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

  Future<void> _save() async {
    await PreferencesService.saveDailyGoals(metins: metins, hedefs: hedefs, sayacs: sayacs, yuzde: yuzde);
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
          ElevatedButton(onPressed: () {
            if (metinCtrl.text.isNotEmpty && int.tryParse(hedefCtrl.text) != null) {
              setState(() {
                metins.add(metinCtrl.text);
                hedefs.add(int.parse(hedefCtrl.text));
                sayacs.add(0);
                _calculate();
                _save();
              });
              Navigator.pop(context);
            }
          }, child: const Text('Kaydet')),
        ],
      ),
    );
  }

  void _calculate() {
    final toplamHedef = hedefs.fold(0, (p, e) => p + e);
    final toplamSayac = sayacs.fold(0, (p, e) => p + e);
    if (toplamHedef > 0) {
      yuzde = ((toplamSayac / toplamHedef) * 100).round();
    } else {
      yuzde = 0;
    }
  }

  void _increment(int i) {
    if (sayacs[i] < hedefs[i]) {
      setState(() {
        sayacs[i]++;
        _calculate();
        _save();
      });
    }
  }

  void _resetAll() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Sıfırla'),
      content: const Text('Tüm sayılar sıfırlanacak, onaylıyor musunuz?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        ElevatedButton(onPressed: () { setState(() { for (var i = 0; i < sayacs.length; i++) {
          sayacs[i] = 0;
        } _calculate(); _save(); }); Navigator.pop(context); }, child: const Text('Evet')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Günlük Hedefler')),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(12.0), child: Text('Tamamlanan hedeflerin durumu: %$yuzde')),
          Expanded(child: metins.isEmpty ? const Center(child: Text('Henüz hedef yok')) : ListView.builder(itemCount: metins.length, itemBuilder: (context, i) {
            final done = sayacs[i] >= hedefs[i];
            return Card(
              color: done ? Colors.green.shade50 : null,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: ListTile(
                title: Text(metins[i], style: TextStyle(fontWeight: done ? FontWeight.bold : FontWeight.normal)),
                subtitle: Text('Hedef: ${hedefs[i]} • Kalan: ${hedefs[i] - sayacs[i]}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.add), onPressed: () => _increment(i)),
                  IconButton(icon: const Icon(Icons.edit), onPressed: () { /* edit dialog similar to add */ }),
                ]),
              ),
            );
          })),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _addGoalDialog, child: const Icon(Icons.add)),
    );
  }
}
