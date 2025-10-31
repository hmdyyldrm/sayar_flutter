// lib/screens/yeni_zikir_screen.dart
import 'package:flutter/material.dart';

class YeniZikirScreen extends StatefulWidget {
  const YeniZikirScreen({super.key});

  @override
  State<YeniZikirScreen> createState() => _YeniZikirScreenState();
}

class _YeniZikirScreenState extends State<YeniZikirScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _hedefController = TextEditingController();

  void _kaydetZikir() {
    if (_formKey.currentState!.validate()) {
      final yeniZikir = {
        'ad': _adController.text.trim(),
        'hedef': int.tryParse(_hedefController.text.trim()) ?? 0,
        'tarih': DateTime.now(),
      };

      // Gelecekte burada SharedPreferences veya SQLite eklenebilir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '"${yeniZikir['ad']}" zikri kaydedildi.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.teal,
        ),
      );

      _adController.clear();
      _hedefController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Zikir Oluştur'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _adController,
                decoration: const InputDecoration(
                  labelText: 'Zikir Adı',
                  hintText: 'Örn: Subhanallah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen zikir adını girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hedefController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Hedef Sayı (isteğe bağlı)',
                  hintText: 'Örn: 33',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _kaydetZikir,
                  icon: const Icon(Icons.save),
                  label: const Text('Kaydet'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _adController.dispose();
    _hedefController.dispose();
    super.dispose();
  }
}
