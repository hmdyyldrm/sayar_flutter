import 'package:flutter/material.dart';

class ZikirDetayScreen extends StatelessWidget {
  final String title;
  final String content;

  const ZikirDetayScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 18, height: 1.4),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
