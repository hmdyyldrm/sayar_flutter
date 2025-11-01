import 'package:flutter/material.dart';
import 'package:sayarapp/database/database_helper.dart';
import 'package:sayarapp/screens/zikir_detay_screen.dart';

class DuaVeZikirScreen extends StatefulWidget {
  const DuaVeZikirScreen({super.key});

  @override
  State<DuaVeZikirScreen> createState() => _DuaVeZikirScreenState();
}

class _DuaVeZikirScreenState extends State<DuaVeZikirScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> tumKayitlar = [];
  List<Map<String, dynamic>> filtreliKayitlar = [];
  bool yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _veriYukle();
  }

  Future<void> _veriYukle() async {
    final db = await DatabaseHelper.instance.database;
    final veriler = await db.query('dua_ve_zikirler');
    setState(() {
      tumKayitlar = veriler;
      filtreliKayitlar = veriler;
      yukleniyor = false;
    });
  }

  void _ara(String query) {
    setState(() {
      if (query.isEmpty) {
        filtreliKayitlar = tumKayitlar;
      } else {
        filtreliKayitlar = tumKayitlar
            .where((item) =>
                item['baslik'].toString().toLowerCase().contains(query.toLowerCase()) ||
                item['icerik'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dua ve Zikirler")),
      body: yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Ara...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: _ara,
                  ),
                ),
                Expanded(
                  child: filtreliKayitlar.isEmpty
                      ? const Center(child: Text("Kayıt bulunamadı"))
                      : ListView.builder(
                          itemCount: filtreliKayitlar.length,
                          itemBuilder: (context, index) {
                            final kayit = filtreliKayitlar[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: ListTile(
                                title: Text(kayit['baslik'] ?? ""),
                                subtitle: Text(
                                  kayit['icerik'].toString().length > 60
                                      ? "${kayit['icerik'].toString().substring(0, 60)}..."
                                      : kayit['icerik'],
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ZikirDetayScreen(
                                      title: kayit['baslik'],
                                      content: kayit['icerik'],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
