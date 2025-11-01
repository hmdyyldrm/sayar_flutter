// lib/screens/esma_screen.dart
import 'package:flutter/material.dart';
import 'details_screen.dart';


class EsmaScreen extends StatelessWidget {
  const EsmaScreen({super.key});

  // Placeholder list — dilersen gerçek içeriği DB/JSON'dan yükleriz
  final List<Map<String, String>> _items = const [
    {'title': 'El Rahman', 'content': 'Merhametli anlamı...'},
    {'title': 'El Rahim', 'content': 'Bağışlayan anlamı...'},
    // ...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Esmaül Hüsna')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) {
          final it = _items[i];
          return ListTile(title: Text(it['title']!), subtitle: Text(it['content']!), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsScreen(title: it['title']!, content: it['content']!))));
        },
      ),
    );
  }
}
