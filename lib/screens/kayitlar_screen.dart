// lib/screens/kayitlar_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KayitlarScreen extends StatefulWidget {
  const KayitlarScreen({super.key});

  @override
  State<KayitlarScreen> createState() => _KayitlarScreenState();
}

class _KayitlarScreenState extends State<KayitlarScreen> {
  List<Map<String, dynamic>> kayitlar = [
    {
      'ad': 'Sabah Zikri',
      'sayi': 33,
      'tarih': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'ad': 'Cuma Tesbihatı',
      'sayi': 99,
      'tarih': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'ad': 'Ayet-el Kürsi Zikri',
      'sayi': 10,
      'tarih': DateTime.now().subtract(const Duration(hours: 6)),
    },
  ];

  void _kayitSil(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kaydı Sil'),
        content: const Text('Bu kaydı silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () {
              setState(() => kayitlar.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  String _formatTarih(DateTime tarih) {
    return DateFormat('dd MMM yyyy - HH:mm', 'tr_TR').format(tarih);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıtlarım'),
        centerTitle: true,
      ),
      body: kayitlar.isEmpty
          ? const Center(child: Text('Henüz bir kayıt bulunmuyor.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: kayitlar.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final kayit = kayitlar[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  leading: CircleAvatar(
                    radius: 24,
                    child: Text(
                      kayit['sayi'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    kayit['ad'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(_formatTarih(kayit['tarih'])),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _kayitSil(index),
                  ),
                );
              },
            ),
    );
  }
}
