// lib/widgets/modern_counter.dart
import 'package:flutter/material.dart';

class ModernCounter extends StatelessWidget {
  final int count;
  final int target;
  final VoidCallback onTap;
  final VoidCallback? onReset;
  final String title;

  const ModernCounter({
    super.key,
    required this.count,
    required this.target,
    required this.onTap,
    this.onReset,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    final ratio = target > 0 ? (count / target).clamp(0.0, 1.0) : 0.0;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
        SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(
                  value: ratio,
                  strokeWidth: 12,
                  backgroundColor: scheme.onSurface.withOpacity(0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                ),
              ),
              Material(
                color: scheme.primary,
                shape: const CircleBorder(),
                elevation: 6,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onTap,
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Center(
                      child: Text(
                        '$count',
                        style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: scheme.onPrimary),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Hedef: $target', style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 12),
          Text('Kalan: ${ (target - count).clamp(0, target) }'),
        ]),
        if (onReset != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextButton.icon(onPressed: onReset, icon: const Icon(Icons.refresh_outlined), label: const Text('Sıfırla')),
          ),
      ],
    );
  }
}
