import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EStudy App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EStudyApp(),
    );
  }
}

class EStudyApp extends StatelessWidget {
  const EStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text("E-Study App!"),
      ),
    );
  }
}
