import 'package:flutter/material.dart';

void main() {
  runApp(const AgriSmartApp());
}

class AgriSmartApp extends StatelessWidget {
  const AgriSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriSmart',
      home: Scaffold(
        appBar: AppBar(title: const Text('AgriSmart')),
        body: const Center(child: Text('AgriSmart Ready')),
      ),
    );
  }
}
