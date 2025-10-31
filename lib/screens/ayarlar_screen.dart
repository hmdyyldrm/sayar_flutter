// lib/screens/ayarlar_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AyarlarScreen extends StatefulWidget {
  const AyarlarScreen({super.key});

  @override
  State<AyarlarScreen> createState() => _AyarlarScreenState();
}

class _AyarlarScreenState extends State<AyarlarScreen> {
  bool soundEnabled = true;
  bool vibrationEnabled = true;
  bool darkMode = false;
  double fontSize = 26;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      soundEnabled = prefs.getBool('sound') ?? true;
      vibrationEnabled = prefs.getBool('vibration') ?? true;
      darkMode = prefs.getBool('isDarkMode') ?? false;
      fontSize = prefs.getDouble('fontSize') ?? 26;
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound', soundEnabled);
    await prefs.setBool('vibration', vibrationEnabled);
    await prefs.setBool('isDarkMode', darkMode);
    await prefs.setDouble('fontSize', fontSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Ses Efekti'),
            subtitle: const Text('Sayaç artarken ses çıkarılsın mı?'),
            value: soundEnabled,
            onChanged: (val) {
              setState(() => soundEnabled = val);
              _savePrefs();
            },
          ),
          SwitchListTile(
            title: const Text('Titreşim'),
            subtitle: const Text('Butona basınca titreşim aktif olsun mu?'),
            value: vibrationEnabled,
            onChanged: (val) {
              setState(() => vibrationEnabled = val);
              _savePrefs();
            },
          ),
          SwitchListTile(
            title: const Text('Gece Modu'),
            subtitle: const Text('Karanlık tema kullanılsın mı?'),
            value: darkMode,
            onChanged: (val) {
              setState(() => darkMode = val);
              _savePrefs();
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Yazı Boyutu: ${fontSize.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            min: 16,
            max: 48,
            divisions: 8,
            label: fontSize.toStringAsFixed(0),
            value: fontSize,
            onChanged: (val) {
              setState(() => fontSize = val);
            },
            onChangeEnd: (_) => _savePrefs(),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Kaydet ve Geri Dön'),
            onPressed: () {
              _savePrefs();
              Navigator.pop(context, {
                'sound': soundEnabled,
                'vibration': vibrationEnabled,
                'fontSize': fontSize,
                'isDarkMode': darkMode,
              });
            },
          ),
        ],
      ),
    );
  }
}
