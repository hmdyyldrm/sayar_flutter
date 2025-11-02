import 'package:flutter/material.dart';
import '../widgets/zikir_card.dart';
import 'dua_ve_zikirler_screen.dart';

class EsmaScreen extends StatelessWidget {
  const EsmaScreen({super.key});

  final List<Map<String, String>> items = const [
    {'title': 'El Rahman', 'content': 'Merhametli anlamı...'},
    {'title': 'El Rahim', 'content': 'Bağışlayan anlamı...'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Esmaül Hüsna')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          final it = items[i];
          return ZikirCard(title: it['title']!, subtitle: it['content']!, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => DuaVeZikirlerScreen()));
          });
        },
      ),
    );
  }
}
