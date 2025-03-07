import 'package:flutter/material.dart';

class GamePendu extends StatefulWidget {
  const GamePendu({super.key});

  @override
  State<GamePendu> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<GamePendu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Widget'),
      ),
      body: const Center(
        child: Text('Hello World!'),
      ),
    );
  }
}
