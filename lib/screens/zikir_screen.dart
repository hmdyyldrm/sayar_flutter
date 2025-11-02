import 'package:flutter/material.dart';
import '../widgets/animated_counter.dart';


class ZikirScreen extends StatefulWidget {
  final int? id;
  final String? baslik;
  final String? icerik;
  const ZikirScreen({super.key, this.id, this.baslik, this.icerik});

  // helper to open from DB map
  factory ZikirScreen.fromMap(Map<String, dynamic> m) {
    return ZikirScreen(id: m['id'] as int?, baslik: m['baslik'] as String?, icerik: m['icerik'] as String?);
  }

  @override
  State<ZikirScreen> createState() => _ZikirScreenState();
}

class _ZikirScreenState extends State<ZikirScreen> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    // if needed, load counter from DB or prefs (not mandatory in original)
  }

  void _increment() {
    setState(() => counter++);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.baslik ?? 'Zikir';
    final content = widget.icerik ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(child: SingleChildScrollView(child: Text(content, style: const TextStyle(fontSize: 18, height: 1.5)))),
          const SizedBox(height: 10),
          AnimatedCounter(count: counter),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton.icon(onPressed: _increment, icon: const Icon(Icons.add), label: const Text('Say')),
            const SizedBox(width: 12),
            ElevatedButton.icon(onPressed: () => setState(() => counter = 0), icon: const Icon(Icons.refresh), label: const Text('Sıfırla')),
          ]),
        ]),
      ),
    );
  }
}
