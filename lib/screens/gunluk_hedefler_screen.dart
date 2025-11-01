import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GunlukHedeflerScreen extends StatefulWidget {
  const GunlukHedeflerScreen({super.key});

  @override
  State<GunlukHedeflerScreen> createState() => _GunlukHedeflerScreenState();
}

class _GunlukHedeflerScreenState extends State<GunlukHedeflerScreen> {
  List<String> goals = [];
  List<int> targets = [];
  List<int> counts = [];

  int progressPercent = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // --- Verileri yükle ---
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final size = prefs.getInt('goalSize') ?? 0;

    goals = List.generate(size, (i) => prefs.getString('goal$i') ?? '');
    targets = List.generate(size, (i) => prefs.getInt('target$i') ?? 0);
    counts = List.generate(size, (i) => prefs.getInt('count$i') ?? 0);

    _calculateProgress();
    setState(() {});
  }

  // --- Verileri kaydet ---
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('goalSize', goals.length);

    for (int i = 0; i < goals.length; i++) {
      prefs.setString('goal$i', goals[i]);
      prefs.setInt('target$i', targets[i]);
      prefs.setInt('count$i', counts[i]);
    }
  }

  // --- Yeni hedef ekle ---
  void _addGoal() {
    String newGoal = '';
    int? newTarget;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Yeni Hedef Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Hedef metni'),
              onChanged: (v) => newGoal = v,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Hedef sayısı'),
              onChanged: (v) => newTarget = int.tryParse(v),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              if (newGoal.isNotEmpty && newTarget != null) {
                setState(() {
                  goals.add(newGoal);
                  targets.add(newTarget!);
                  counts.add(0);
                });
                _calculateProgress();
                _saveData();
                Navigator.pop(context);
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  // --- Hedef düzenleme ---
  void _editGoal(int index) {
    String editedGoal = goals[index];
    int editedTarget = targets[index];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hedefi Düzenle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: editedGoal),
              decoration: const InputDecoration(labelText: 'Metin'),
              onChanged: (v) => editedGoal = v,
            ),
            TextField(
              controller:
                  TextEditingController(text: editedTarget.toString()),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Sayı'),
              onChanged: (v) => editedTarget = int.tryParse(v) ?? editedTarget,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                goals[index] = editedGoal;
                targets[index] = editedTarget;
              });
              _calculateProgress();
              _saveData();
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  // --- Sayaç artır ---
  void _incrementCount(int index) {
    if (counts[index] < targets[index]) {
      setState(() {
        counts[index]++;
      });
      _calculateProgress();
      _saveData();
    }
  }

  // --- Sayaçları sıfırla ---
  void _resetAll() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sayaçları Sıfırla'),
        content: const Text('Tüm sayaçlar sıfırlanacak, emin misiniz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                counts = List.generate(counts.length, (_) => 0);
              });
              _calculateProgress();
              _saveData();
              Navigator.pop(context);
            },
            child: const Text('Evet'),
          ),
        ],
      ),
    );
  }

  // --- İlerleme yüzdesi ---
  void _calculateProgress() {
    int totalTarget = targets.fold(0, (a, b) => a + b);
    int totalCount = counts.fold(0, (a, b) => a + b);
    if (totalTarget > 0) {
      progressPercent = ((totalCount / totalTarget) * 100).floor();
    } else {
      progressPercent = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Günlük Hedefler'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetAll,
              tooltip: 'Sayaçları sıfırla')
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGoal,
        child: const Icon(Icons.add),
      ),
      body: goals.isEmpty
          ? const Center(child: Text('Henüz hedef eklenmemiş'))
          : ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, i) {
                final isDone = counts[i] >= targets[i];
                return ListTile(
                  title: Text(
                    goals[i],
                    style: TextStyle(
                      color: isDone ? Colors.green : Colors.black,
                      fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                      'Hedef: ${targets[i]} | Sayı: ${counts[i]} | Kalan: ${targets[i] - counts[i]}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editGoal(i)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => _incrementCount(i),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        padding: const EdgeInsets.all(12),
        child: Text(
          'Tamamlanan hedeflerin durumu: %$progressPercent',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
