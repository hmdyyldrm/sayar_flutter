import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sayar"),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE0F2F1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildMenuButton(
              context,
              title: "Zikirmatik",
              icon: Icons.countertops,
              route: "/zikirmatik",
            ),
            _buildMenuButton(
              context,
              title: "Günlük Hedefler",
              icon: Icons.flag,
              route: "/gunluk",
            ),
            _buildMenuButton(
              context,
              title: "Dua ve Zikirler",
              icon: Icons.menu_book,
              route: "/dua",
            ),
            _buildMenuButton(
              context,
              title: "Esmaül Hüsna",
              icon: Icons.star,
              route: "/esma",
            ),
            _buildMenuButton(
              context,
              title: "Ayarlar",
              icon: Icons.settings,
              route: "/ayarlar",
            ),
            _buildMenuButton(
              context,
              title: "Hakkında",
              icon: Icons.info_outline,
              route: "/hakkinda",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required String title, required IconData icon, required String route}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(12),
        elevation: 4,
      ),
      onPressed: () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
