// lib/screens/main_page.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dua_ve_zikir_screen.dart';
import 'ayarlar_screen.dart';
import 'kayitlar_screen.dart';
import 'yeni_zikir_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zikir Uygulaması'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuButton(
              context,
              title: 'Zikirmatik',
              icon: Icons.countertops,
              color: Colors.teal,
              page: const HomeScreen(
                isDarkMode: false,
                onThemeChanged: _dummyThemeChange,
              ),
            ),
            _buildMenuButton(
              context,
              title: 'Dua ve Zikirler',
              icon: Icons.book,
              color: Colors.deepPurple,
              page: const DuaVeZikirScreen(),
            ),
            _buildMenuButton(
              context,
              title: 'Yeni Zikir',
              icon: Icons.add_circle_outline,
              color: Colors.green,
              page: const YeniZikirScreen(),
            ),
            _buildMenuButton(
              context,
              title: 'Kayıtlar',
              icon: Icons.history,
              color: Colors.blueGrey,
              page: const KayitlarScreen(),
            ),
            _buildMenuButton(
              context,
              title: 'Ayarlar',
              icon: Icons.settings,
              color: Colors.orange,
              page: const AyarlarScreen(),
            ),
          ],
        ),
      ),
    );
  }

  static void _dummyThemeChange(bool _) {}

  Widget _buildMenuButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 48),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
