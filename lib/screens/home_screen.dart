// lib/screens/home_screen.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  //final Function(bool) onThemeChanged;
  const HomeScreen({
    super.key,
    required this.isDarkMode,
   // required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int counter = 0;
  int goal = 0;
  double fontSize = 26;
  String text = '';
  bool hasGoal = false;
  bool vibrationEnabled = true;
  bool soundEnabled = true;

  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = prefs.getInt('counter') ?? 0;
      goal = prefs.getInt('goal') ?? 0;
      text = prefs.getString('text') ?? '';
      hasGoal = prefs.getBool('hasGoal') ?? false;
      fontSize = prefs.getDouble('fontSize') ?? 26;
      vibrationEnabled = prefs.getBool('vibration') ?? true;
      soundEnabled = prefs.getBool('sound') ?? true;
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', counter);
    await prefs.setInt('goal', goal);
    await prefs.setString('text', text);
    await prefs.setBool('hasGoal', hasGoal);
    await prefs.setDouble('fontSize', fontSize);
    await prefs.setBool('vibration', vibrationEnabled);
    await prefs.setBool('sound', soundEnabled);
  }

  void _increment() async {
    setState(() => counter++);
    if (soundEnabled) _player.play(AssetSource('sounds/tap.mp3'));
    if (vibrationEnabled) Vibration.vibrate(duration: 60);
    if (hasGoal && counter >= goal) {
      _showGoalReachedDialog();
    }
    _savePrefs();
  }

  void _resetCounter() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sıfırla'),
        content: const Text('Sayacı sıfırlamak istediğine emin misin?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal')),
          TextButton(
              onPressed: () {
                setState(() => counter = 0);
                _savePrefs();
                Navigator.pop(context);
              },
              child: const Text('Evet')),
        ],
      ),
    );
  }

  void _showGoalDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hedef Belirle'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Hedef sayıyı girin'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal')),
          TextButton(
            onPressed: () {
              setState(() {
                goal = int.tryParse(controller.text) ?? 0;
                hasGoal = true;
              });
              _savePrefs();
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showGoalReachedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tebrikler 🎉'),
        content: const Text('Belirlenen hedefe ulaştınız!'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam')),
        ],
      ),
    );
  }

  void _shareCounter() {
    Share.share('Zikir Sayım: $counter\nMetin: $text');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zikir Sayacı'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight),
            onPressed: () =>
               // widget.onThemeChanged(!widget.isDarkMode)
               print("sdf")
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'vibration') {
                setState(() => vibrationEnabled = !vibrationEnabled);
              } else if (value == 'sound') {
                setState(() => soundEnabled = !soundEnabled);
              } else if (value == 'reset') {
                _resetCounter();
              }
              _savePrefs();
            },
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                value: 'vibration',
                checked: vibrationEnabled,
                child: const Text('Titreşim'),
              ),
              CheckedPopupMenuItem(
                value: 'sound',
                checked: soundEnabled,
                child: const Text('Ses'),
              ),
              const PopupMenuItem(value: 'reset', child: Text('Sıfırla')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Zikir veya dua metni'),
              onChanged: (v) {
                setState(() => text = v);
                _savePrefs();
              },
              controller: TextEditingController(text: text),
            ),
            const SizedBox(height: 20),
            Text(
              '$counter',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasGoal)
              Text(
                'Hedef: $goal',
                style: const TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Artır'),
              onPressed: _increment,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.flag),
              label: const Text('Hedef Belirle'),
              onPressed: _showGoalDialog,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Paylaş'),
              onPressed: _shareCounter,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
