import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Sayar'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          children: [
            _tile(context, Icons.countertops, 'Zikirmatik', '/zikirmatik'),
            _tile(context, Icons.flag, 'Günlük Hedefler', '/gunluk'),
            _tile(context, Icons.menu_book, 'Dua & Zikirler', '/duavezikir'),
            _tile(context, Icons.star, 'Esmaül Hüsna', '/esma'),
            _tile(context, Icons.settings, 'Ayarlar', '/ayarlar'),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, String route) {
    final color = Theme.of(context).colorScheme.primary;
    return Material(
      borderRadius: BorderRadius.circular(14),
      color: color.withOpacity(0.08),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 44, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }
}
