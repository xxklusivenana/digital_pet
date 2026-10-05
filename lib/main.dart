import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const DigitalPet());
}

class DigitalPet extends StatelessWidget {
  const DigitalPet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Pet State Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const DigitalPetScreen(),
    );
  }
}

class DigitalPetScreen extends StatefulWidget {
  const DigitalPetScreen({super.key});

  @override
  State<DigitalPetScreen> createState() => _DigitalPetScreenState();
}

class _DigitalPetScreenState extends State<DigitalPetScreen> {
  // initial game states & values
  static const int _initialHappiness = 60;
  static const int _initialHunger = 95;

  int _happiness = _initialHappiness;
  int _hunger = _initialHunger;

  bool _hasWon = false;
  bool _gameOver = false;

  String _selectedAction = 'None';
  String _resultMessage = 'Try an action';

  Timer? _hungerTimer;
  Timer? _winTimer;

  static const Duration _hungerTickInterval = Duration(seconds: 30);
  static const Duration _winDuration = Duration(minutes: 3);
}