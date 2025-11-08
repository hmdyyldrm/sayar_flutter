import 'package:flutter/material.dart';
import 'package:sayarapp/database/database_helper.dart';
import '../widgets/zikir_card.dart';
import 'zikir_screen.dart';

class DuaVeZikirlerScreen extends StatefulWidget {
  const DuaVeZikirlerScreen({super.key});

  @override
  State<DuaVeZikirlerScreen> createState() => _DuaVeZikirlerScreenState();
}

class _DuaVeZikirlerScreenState extends State<DuaVeZikirlerScreen> {
  List<Map<String, dynamic>> items = [];
  bool loading = true;
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rows = await DatabaseHelper.instance.getAllZikirler();
    setState(() {
      items = rows;
      loading = false;
    });
  }

  void _openItem(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ZikirScreen.fromMap(item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _search.text.isEmpty
        ? items
        : items.where((r) {
            final s = _search.text.toLowerCase();
            return (r['baslik'] ?? '').toString().toLowerCase().contains(s) ||
                (r['icerik'] ?? '').toString().toLowerCase().contains(s);
          }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Dua & Zikirler')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Ara...'),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(child: Text('Kayıt bulunamadı'))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final it = filtered[i];
                          return Dismissible(
                            key: ValueKey(it['id']),
                            background: Container(color: Colors.redAccent, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), child: const Icon(Icons.delete, color: Colors.white)),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) async {
                              await DatabaseHelper.instance.deleteZikir(it['id'] as int);
                              _load();
                            },
                            child: ZikirCard(
                              title: it['baslik'] ?? '',
                              subtitle: (it['icerik'] ?? '').toString().split('\n').first,
                              onTap: () => _openItem(it),
                            ),
                          );
                        },
                      ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/yeni_zikir').then((_) => _load()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
