import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class ZikirmatikScreen extends StatefulWidget {
  const ZikirmatikScreen({super.key});

  @override
  State<ZikirmatikScreen> createState() => _ZikirmatikScreenState();
}

class _ZikirmatikScreenState extends State<ZikirmatikScreen> {
  int sayac = 0;
  int hedef = 33;
  bool sesEtkin = true;
  bool titresimEtkin = true;
  late SharedPreferences prefs;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  Future<void> _verileriYukle() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      sayac = prefs.getInt('zikir_sayac') ?? 0;
      hedef = prefs.getInt('zikir_hedef') ?? 33;
      sesEtkin = prefs.getBool('sesEtkin') ?? true;
      titresimEtkin = prefs.getBool('titresimEtkin') ?? true;
    });
  }

  Future<void> _verileriKaydet() async {
    await prefs.setInt('zikir_sayac', sayac);
    await prefs.setInt('zikir_hedef', hedef);
    await prefs.setBool('sesEtkin', sesEtkin);
    await prefs.setBool('titresimEtkin', titresimEtkin);
  }

  void _arttir() {
    if (sayac < hedef) {
      setState(() => sayac++);
      if (sesEtkin) player.play(AssetSource('sounds/click.mp3'));
      if (titresimEtkin) Vibration.vibrate(duration: 60);
      _verileriKaydet();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hedef tamamlandı 🌙")),
      );
    }
  }

  void _sifirla() {
    setState(() => sayac = 0);
    _verileriKaydet();
  }

  void _hedefDegistir(BuildContext context) {
    final controller = TextEditingController(text: hedef.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Yeni hedef belirle"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Yeni hedef sayısı"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () {
              setState(() => hedef = int.tryParse(controller.text) ?? 33);
              _verileriKaydet();
              Navigator.pop(context);
            },
            child: const Text("Kaydet"),
          )
        ],
      ),
    );
  }

  void _ayarlarMenusu() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text("Ses efekti"),
              value: sesEtkin,
              onChanged: (v) {
                setState(() => sesEtkin = v);
                _verileriKaydet();
              },
            ),
            SwitchListTile(
              title: const Text("Titreşim"),
              value: titresimEtkin,
              onChanged: (v) {
                setState(() => titresimEtkin = v);
                _verileriKaydet();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final oran = (sayac / hedef).clamp(0, 1.0);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zikirmatik"),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: _ayarlarMenusu),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hedef: $hedef", style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 10),
            Text("Sayaç: $sayac", style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: oran,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(oran == 1.0 ? Colors.green : Colors.teal),
                  ),
                  IconButton(
                    icon: const Icon(Icons.fingerprint, size: 70, color: Colors.teal),
                    onPressed: _arttir,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              children: [
                ElevatedButton.icon(
                  onPressed: _sifirla,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Sıfırla"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _hedefDegistir(context),
                  icon: const Icon(Icons.edit),
                  label: const Text("Hedef"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
