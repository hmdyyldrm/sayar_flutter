// lib/screens/auth_screens.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GirisScreen extends StatefulWidget {
  const GirisScreen({super.key});

  @override
  State<GirisScreen> createState() => _GirisScreenState();
}

class _GirisScreenState extends State<GirisScreen> {
  final TextEditingController _pwCtrl = TextEditingController();
  String _status = '';

  Future<void> _checkPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('password') ?? '';
    if (saved.isEmpty) {
      // no password set — accept and continue
      Navigator.of(context).pushReplacementNamed('/main');
      return;
    }
    if (_pwCtrl.text == saved) {
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      setState(() => _status = 'Şifre yanlış');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _pwCtrl, decoration: const InputDecoration(labelText: 'Şifre'), obscureText: true),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _checkPassword, child: const Text('Giriş')),
          const SizedBox(height: 8),
          Text(_status, style: const TextStyle(color: Colors.red)),
        ]),
      ),
    );
  }
}

class SifreAyarScreen extends StatefulWidget {
  const SifreAyarScreen({super.key});

  @override
  State<SifreAyarScreen> createState() => _SifreAyarScreenState();
}

class _SifreAyarScreenState extends State<SifreAyarScreen> {
  final TextEditingController _pw1 = TextEditingController();
  final TextEditingController _pw2 = TextEditingController();
  String _msg = '';

  Future<void> _savePassword() async {
    if (_pw1.text != _pw2.text) {
      setState(() => _msg = 'Şifreler uyuşmuyor');
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', _pw1.text);
    setState(() => _msg = 'Kaydedildi');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Şifre Ayarları')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _pw1, decoration: const InputDecoration(labelText: 'Yeni Şifre'), obscureText: true),
          const SizedBox(height: 12),
          TextField(controller: _pw2, decoration: const InputDecoration(labelText: 'Yeni Şifre (Tekrar)'), obscureText: true),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _savePassword, child: const Text('Kaydet')),
          const SizedBox(height: 8),
          Text(_msg),
        ]),
      ),
    );
  }
}
