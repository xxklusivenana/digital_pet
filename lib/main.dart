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

    _hungerTimer = Timer.periodic(_hungerTickInterval, (_) {
      if (!mounted || _gameOver || _hasWon) return;

      final nextHunger = _clampMeter(_hunger + 5);

      setState(() {
        _hunger = nextHunger;
        _selectedAction = 'Time';
        _resultMessage = 'Time passed. Hunger +5.';
      });

      _updateOutcome();
    });
  }

  int _clampMeter(int value) { // bounded meter helper
    return value.clamp(0, 100).toInt();
  }

  void _feedPet() {
    if (_gameOver || _hasWon) return;

    final nextHunger = _clampMeter(_hunger - 10);
    final happinessChange = nextHunger < 30 ? -20 : 10;
    final nextHappiness =
        _clampMeter(_happiness + happinessChange);

    setState(() {
      _hunger = nextHunger;
      _happiness = nextHappiness;
      _selectedAction = 'Feed';
      _resultMessage = happinessChange < 0
          ? 'Fed the pet, but it was already very hungry.'
          : 'Fed the pet. Hunger -10, Happiness +10.';
    });

    _updateOutcome();
  }

  void _playWithPet() {
    if (_gameOver || _hasWon) return;

    // The pet needs enough energy to play.
    if (_energy < 10) {
      setState(() {
        _selectedAction = 'Play';
        _resultMessage = 'Too tired to play. Let the pet rest!';
      });
      return;
    }

    final nextEnergy = _clampMeter(_energy - 10);
    final nextHunger = _clampMeter(_hunger + 5);
    final nextHappiness = _clampMeter(_happiness + 15);

    setState(() {
      _energy = nextEnergy;
      _hunger = nextHunger;
      _happiness = nextHappiness;
      _selectedAction = 'Play';
      _resultMessage =
          'Played with the pet. Happiness +15, Energy -10, Hunger +5.';
    });

    _updateOutcome();
  }

  void _putToSleep() {
    if (_gameOver || _hasWon) return;

    final nextEnergy = _clampMeter(_energy + 20);
    final nextHunger = _clampMeter(_hunger + 5);

    setState(() {
      _energy = nextEnergy;
      _hunger = nextHunger;
      _selectedAction = 'Rest';
      _resultMessage = 'Rested. Energy +20, Hunger +5.';
    });

    _updateOutcome();
  }

  void _resetGame() {
    _winTimer?.cancel();
    _winTimer = null;

    setState(() {
      _happiness = _initialHappiness;
      _hunger = _initialHunger;
      _energy = _initialEnergy;

      _hasWon = false;
      _gameOver = false;

      _selectedAction = 'Reset';
      _resultMessage = 'Pet reset. Try an action!';
    });

    // The reset must leave exactly one hunger timer active.
    _startHungerTimer();
  }

  void _updateOutcome() {
    if (!mounted) return;

    // LOSS: Hunger must be exactly 100 and happiness must be <= 10.
    if (_hunger >= 100 && _happiness <= 10) {
      _winTimer?.cancel();
      _winTimer = null;

      if (!_gameOver && !_hasWon) {
        setState(() {
          _gameOver = true;
          _resultMessage = 'Game over! Your pet needs care.';
        });
      }
      return;
    }

    _updateWinTimer();
  }

  void _updateWinTimer() {
    if (_gameOver || _hasWon) return;

    if (_happiness <= 80) {
      _winTimer?.cancel();
      _winTimer = null;
      return;
    }

    // Start the three-minute timer only if one isnt already running.
    if (_winTimer == null) {
      _winTimer = Timer(_winDuration, () {
        if (!mounted || _gameOver) return;

        if (_happiness > 80) {
          setState(() {
            _hasWon = true;
            _resultMessage = 'You win! Your pet stayed happy!';
          });
        }

        _winTimer = null;
      });
    }
  }
}