import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

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
    final p = await SharedPreferences.getInstance();
    setState(() {
      ses = p.getBool('ses') ?? false;
      titresim = p.getBool('titresim') ?? true;
      gece = p.getBool('geceModu') ?? false;
    });
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('ses', ses);
    await p.setBool('titresim', titresim);
    await p.setBool('geceModu', gece);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ayarlar kaydedildi')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          SwitchListTile(title: const Text('Ses'), value: ses, onChanged: (v) => setState(() => ses = v)),
          SwitchListTile(title: const Text('Titreşim'), value: titresim, onChanged: (v) => setState(() => titresim = v)),
          SwitchListTile(title: const Text('Gece Modu'), value: gece, onChanged: (v) => setState(() => gece = v)),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _save, child: const Text('Kaydet')),
        ]),
      ),
    );
  }
}
