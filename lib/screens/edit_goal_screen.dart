// lib/screens/edit_goal_screen.dart
import 'package:flutter/material.dart';

class EditGoalScreen extends StatefulWidget {
  final int index;
  final String metin;
  final int hedef;
  final int sayac;

  const EditGoalScreen({super.key, required this.index, required this.metin, required this.hedef, required this.sayac});

  @override
  State<EditGoalScreen> createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  late TextEditingController _metinCtrl;
  late TextEditingController _hedefCtrl;
  late TextEditingController _sayacCtrl;

  @override
  void initState() {
    super.initState();
    _metinCtrl = TextEditingController(text: widget.metin);
    _hedefCtrl = TextEditingController(text: widget.hedef.toString());
    _sayacCtrl = TextEditingController(text: widget.sayac.toString());
  }

  @override
  void dispose() {
    _metinCtrl.dispose();
    _hedefCtrl.dispose();
    _sayacCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final metin = _metinCtrl.text.trim();
    final hedef = int.tryParse(_hedefCtrl.text.trim()) ?? 0;
    final sayac = int.tryParse(_sayacCtrl.text.trim()) ?? 0;
    Navigator.pop(context, {'metin': metin, 'hedef': hedef, 'sayac': sayac});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hedefi Düzenle'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _save)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _metinCtrl, decoration: const InputDecoration(labelText: 'Hedef metni')),
            const SizedBox(height: 12),
            TextField(controller: _hedefCtrl, decoration: const InputDecoration(labelText: 'Hedef sayı'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _sayacCtrl, decoration: const InputDecoration(labelText: 'Mevcut sayaç'), keyboardType: TextInputType.number),
          ],
        ),
      ),
    );
  }
}
