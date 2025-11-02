import 'package:flutter/material.dart';
import '../services/db_helper.dart';

class YeniZikirScreen extends StatefulWidget {
  const YeniZikirScreen({super.key});

  @override
  State<YeniZikirScreen> createState() => _YeniZikirScreenState();
}

class _YeniZikirScreenState extends State<YeniZikirScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty || content.isEmpty) return;
    await DBHelper.insert('zikirler', {'baslik': title, 'icerik': content});
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Dua / Zikir')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Başlık')),
          const SizedBox(height: 12),
          Expanded(child: TextField(controller: _contentCtrl, decoration: const InputDecoration(labelText: 'İçerik'), maxLines: null, expands: true)),
          ElevatedButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: const Text('Kaydet')),
        ]),
      ),
    );
  }
}
