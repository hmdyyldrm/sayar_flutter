import 'package:flutter/material.dart';

class ZikirCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const ZikirCard({super.key, required this.title, required this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: scheme.primary),
      ),
    );
  }
}
