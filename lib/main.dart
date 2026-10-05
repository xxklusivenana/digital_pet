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
  static const int _initialHappiness = 50;
  static const int _initialHunger = 50;
  static const int _initialEnergy = 70;

  int _happiness = _initialHappiness;
  int _hunger = _initialHunger;
  int _energy = _initialEnergy;

  bool _hasWon = false;
  bool _gameOver = false;

  String _selectedAction = 'None';
  String _resultMessage = 'Try an action';

  Timer? _hungerTimer;
  Timer? _winTimer;

  static const Duration _hungerTickInterval = Duration(seconds: 30);
  static const Duration _winDuration = Duration(minutes: 3);

  @override
  void dispose() {
    // Always cancel periodic/one-shot timers owned by this State.
    _hungerTimer?.cancel();
    _winTimer?.cancel();

    super.dispose();
  }

  void _startHungerTimer() {
    _hungerTimer?.cancel(); // no duplicate timers
  }

  int _clampMeter(int value) { // bounded meter helper
    return value.clamp(0, 100).toInt();
  }

  void _feedPet() {

  }

  void _playWithPet() {

  }

  void _putToSleep() {
    
  }

  void _resetGame() { // Restore initial values, one hunger timer

  }

  void _updateOutcome() {

  }

  void _updateWinTimer() {

  }
}