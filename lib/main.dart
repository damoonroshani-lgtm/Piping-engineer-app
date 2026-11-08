import 'package:flutter/material.dart';

void main() {
  runApp(const PipingApp());
}

class PipingApp extends StatelessWidget {
  const PipingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Piping Engineering',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piping Engineering'),
      ),
      body: const Center(
        child: Text(
          'Industrial Piping Engineering',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
