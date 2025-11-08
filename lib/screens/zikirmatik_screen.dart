import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class ZikirmatikScreen extends StatefulWidget {
  final String title;
  final int initialTarget;
  final int initialCount;
  final int zikirId; // database ID

  const ZikirmatikScreen({
    super.key,
    required this.title,
    required this.initialTarget,
    required this.initialCount,
    required this.zikirId,
  });

  @override
  State<ZikirmatikScreen> createState() => _ZikirmatikScreenState();
}

class _ZikirmatikScreenState extends State<ZikirmatikScreen> {
  final dbHelper = DatabaseHelper.instance;

  late int counter;
  late int hedef;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    counter = widget.initialCount;
    hedef = widget.initialTarget;
    _loadZikir();
  }

  Future<void> _loadZikir() async {
    final data = await dbHelper.getZikirById(widget.zikirId);
    if (data != null) {
      setState(() {
        counter = int.tryParse(data[DatabaseHelper.columnSayac] ?? '0') ?? 0;
        hedef = int.tryParse(data[DatabaseHelper.columnHedef] ?? '0') ?? 0;
        isLoading = false;
      });
    } else {
      // yeni kayıt değilse mevcut değerlerle devam
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateZikir() async {
    await dbHelper.updateZikir(widget.zikirId, {
      DatabaseHelper.columnSayac: counter.toString(),
      DatabaseHelper.columnToplam: counter.toString(),
      DatabaseHelper.columnGuncellemeTarih: DateTime.now().toString(),
    });
  }

  void _incrementCounter() {
    if (counter < hedef) {
      setState(() => counter++);
      _updateZikir();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tebrikler! Hedefe ulaştınız 🎯')),
      );
    }
  }

  void _resetCounter() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sıfırlama'),
        content: const Text('Sayaç sıfırlansın mı?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hayır')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Evet')),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => counter = 0);
      _updateZikir();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final progress = hedef > 0 ? (counter / hedef).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _resetCounter),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Modern progress göstergesi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: Colors.grey.shade300,
              ),
            ),

            Text(
              '$counter / $hedef',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // ✅ Modern büyük sayaç butonu (Material 3 uyumlu)
            GestureDetector(
              onTap: _incrementCounter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: progress >= 1.0 ? Colors.green.shade400 : Colors.blue.shade500,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.fingerprint, color: Colors.white, size: 70),
                ),
              ),
            ),

            const SizedBox(height: 25),
            Text(
              progress >= 1.0 ? "Hedef Tamamlandı 🎉" : "Zikri Saymak için dokun",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
