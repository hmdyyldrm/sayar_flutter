// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'; // for ThemeController type

class SettingsScreen extends StatefulWidget {
  final ThemeController controller;
  const SettingsScreen({super.key, required this.controller});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool ses = false;
  bool titresim = true;
  bool gece = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ses = prefs.getBool('ses') ?? false;
      titresim = prefs.getBool('titresim') ?? true;
      gece = prefs.getBool('geceModu') ?? false;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _onGeceChanged(bool v) async {
    setState(() => gece = v);
    await _saveBool('geceModu', v);
    widget.controller.setMode(v ? ThemeMode.dark : ThemeMode.light);
  }

  void _onSesChanged(bool v) async {
    setState(() => ses = v);
    await _saveBool('ses', v);
  }

  void _onTitresimChanged(bool v) async {
    setState(() => titresim = v);
    await _saveBool('titresim', v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Ses'),
              value: ses,
              onChanged: _onSesChanged,
            ),
            SwitchListTile(
              title: const Text('Titreşim'),
              value: titresim,
              onChanged: _onTitresimChanged,
            ),
            SwitchListTile(
              title: const Text('Gece Modu'),
              value: gece,
              onChanged: _onGeceChanged,
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uygulama ayarları temizlendi')));
            }, child: const Text('Tüm Ayarları Sıfırla (test)')),
          ],
        ),
      ),
    );
  }
}
