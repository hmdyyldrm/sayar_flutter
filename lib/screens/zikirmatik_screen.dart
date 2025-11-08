// lib/screens/zikirmatik_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/modern_counter.dart';

class ZikirmatikScreen extends StatefulWidget {
  final String? title;
  final int? initialTarget;
  final int? initialCount;
  final int? goalIndex; // if opened for a specific goal index, save back to metin{i}/sayac{i}/hedef{i}

  const ZikirmatikScreen({super.key, this.title, this.initialTarget, this.initialCount, this.goalIndex});

  @override
  State<ZikirmatikScreen> createState() => _ZikirmatikScreenState();
}

class _ZikirmatikScreenState extends State<ZikirmatikScreen> {
  late int count;
  late int target;
  String titleText = '';

  @override
  void initState() {
    super.initState();
    count = widget.initialCount ?? 0;
    target = widget.initialTarget ?? 33;
    titleText = widget.title ?? 'Zikirmatik';
  }

  Future<void> _increment() async {
    if (count < target) {
      setState(() => count++);
      await _maybeSaveBack();
    } else {
      // already reached target - still allow!
      setState(() => count++);
      await _maybeSaveBack();
    }
  }

  Future<void> _reset() async {
    setState(() => count = 0);
    await _maybeSaveBack();
  }

  Future<void> _maybeSaveBack() async {
    if (widget.goalIndex != null) {
      final prefs = await SharedPreferences.getInstance();
      final i = widget.goalIndex!;
      await prefs.setInt('sayac$i', count);
      // hedef ve metin zaten mevcut, güncelle gerekirse de yapılır
    }
    // If it's a custom zikir stored by key, user should use specialized screen; here we just support goals back-save
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titleText)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
          child: Column(
            children: [
              ModernCounter(
                title: titleText,
                count: count,
                target: target,
                onTap: _increment,
                onReset: _reset,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // open a dialog to change target
                  final ctrl = TextEditingController(text: target.toString());
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Hedefi Değiştir'),
                      content: TextField(controller: ctrl, keyboardType: TextInputType.number),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
                        ElevatedButton(
                          onPressed: () async {
                            final v = int.tryParse(ctrl.text) ?? target;
                            setState(() => target = v);
                            if (widget.goalIndex != null) {
                              final i = widget.goalIndex!;
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setInt('hedef$i', target);
                            }
                            Navigator.pop(context);
                          },
                          child: const Text('Kaydet'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.flag),
                label: const Text('Hedefi Düzenle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
