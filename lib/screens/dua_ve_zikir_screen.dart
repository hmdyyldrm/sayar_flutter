// lib/screens/dua_ve_zikir_screen.dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class DuaVeZikirScreen extends StatefulWidget {
  const DuaVeZikirScreen({super.key});

  @override
  State<DuaVeZikirScreen> createState() => _DuaVeZikirScreenState();
}

class _DuaVeZikirScreenState extends State<DuaVeZikirScreen> {
  // Bu listeyi istersen shared_preferences veya local json ile doldurabiliriz.
  final List<Map<String, String>> duaList = [
    {
      'baslik': 'Sabah Duası',
      'icerik': 'Allahümme inni es’elüke ilmen nafian ve rızkan tayyiban...'
    },
    {
      'baslik': 'Akşam Duası',
      'icerik': 'Allahümme bismike ehya ve bismike emut...'
    },
    {
      'baslik': 'Seyahat Duası',
      'icerik': 'Sübhanellezi sehhara lena hâza...'
    },
    {
      'baslik': 'Namaz Sonrası Zikir',
      'icerik': 'Estağfirullah (3x), Allahümme entesselam...'
    },
  ];

  void _showDetail(Map<String, String> dua) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dua['baslik']!,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              dua['icerik']!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Paylaş'),
                onPressed: () {
                  Share.share('${dua['baslik']}\n\n${dua['icerik']}');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dua ve Zikirler'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: duaList.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final dua = duaList[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            title: Text(
              dua['baslik']!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () => _showDetail(dua),
          );
        },
      ),
    );
  }
}
