import 'package:flutter/material.dart';

class AnimatedCounter extends StatelessWidget {
  final int count;
  const AnimatedCounter({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
      child: Text('$count', key: ValueKey<int>(count), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
    );
  }
}
