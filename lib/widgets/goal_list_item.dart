// lib/widgets/goal_list_item.dart
import 'package:flutter/material.dart';

class GoalListItem extends StatelessWidget {
  final String title;
  final int hedef;
  final int sayac;
  final VoidCallback onIncrement;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReset;

  const GoalListItem({
    super.key,
    required this.title,
    required this.hedef,
    required this.sayac,
    required this.onIncrement,
    required this.onEdit,
    required this.onDelete,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (hedef - sayac).clamp(0, hedef);
    final completed = sayac >= hedef && hedef > 0;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: completed ? Colors.green : null)),
        subtitle: Text('Hedef: $hedef • Kalan: $remaining'),
        leading: CircleAvatar(child: Text('$sayac')),
        trailing: Wrap(
          spacing: 6,
          children: [
            IconButton(icon: const Icon(Icons.add), tooltip: 'Sayacı Arttır', onPressed: onIncrement),
            IconButton(icon: const Icon(Icons.edit), tooltip: 'Düzenle', onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete_outline), tooltip: 'Sil', onPressed: onDelete),
          ],
        ),
        onLongPress: onReset,
      ),
    );
  }
}
