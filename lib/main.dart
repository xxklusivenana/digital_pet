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

  String _petName = 'Buddy'; 
 
  final TextEditingController _nameController = TextEditingController(); 
 
  String get _petMessage { 
    if (_gameOver) return 'Game Over!.'; 
    if (_hasWon) return 'You Win! Best day ever! So Happy!'; 
    if (_hunger > 80) return "I'm starving!"; 
    if (_happiness <= 30) return 'Play with me? :()'; 
    if (_energy < 20) return 'I am too sleepy!';
    return "Hi, I'm $_petName!"; 
  } 
 
  Color get _moodColor { 
    if (_happiness > 70) return Colors.green; 
    if (_happiness >= 30) return Colors.yellow; 
    return Colors.red; 
  } 
 
  double get _petScale => 
      _happiness > 70 ? 1.06 : (_happiness < 30 ? 0.94 : 1.0); 
 
  int _clamp(int val) => val.clamp(0, 100); 
 
  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  @override 
  void dispose() { 
    _hungerTimer?.cancel(); 
    _winTimer?.cancel(); 
    _nameController.dispose(); 
 
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
 
  int _clampMeter(int value) {
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
 
    // lower hunger left
    _startHungerTimer(); 
  } 
 
  void _updateOutcome() { 
    if (!mounted) return; 
 
    // LOSS: Hunger must be 100 and happiness me around 10 or below
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

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet State Lab'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: 'Reset Pet',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Pet Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.trim().isNotEmpty) {
                      setState(() {
                        _petName = _nameController.text.trim();
                      });
                    }
                  },
                  child: const Text('Set Name'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            AnimatedSwitcher(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 300),
              child: Text(
                _petMessage,
                key: ValueKey<String>(_petMessage),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            AnimatedScale(
              scale: _petScale,
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _moodColor,
                  BlendMode.modulate,
                ),
                child: Image.asset(
                  'assets/images/animal_1.png',
                  height: 160,
                  width: 160,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 160,
                      width: 160,
                      color: Colors.grey.shade300,
                      child: Icon(
                        Icons.pets,
                        size: 80,
                        color: _moodColor,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              'Mood: ${_happiness > 70 ? "Happy" : (_happiness >= 30 ? "Neutral" : "Unhappy")}',
              style: TextStyle(
                color: _moodColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Happiness: $_happiness',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 4),

            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: _happiness / 100,
              ),
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 10,
                color: Colors.green,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hunger: $_hunger',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 4),

            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: _hunger / 100,
              ),
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 10,
                color: Colors.orange,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 32),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Energy: $_energy',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 4),

            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: _energy / 100,
              ),
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 10,
                color: Colors.blue,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: (_gameOver || _hasWon)
                      ? null
                      : _feedPet,
                  icon: const Icon(Icons.fastfood),
                  label: const Text('Feed'),
                ),
                ElevatedButton.icon(
                  onPressed: (_gameOver || _hasWon)
                      ? null
                      : _playWithPet,
                  icon: const Icon(Icons.sports_esports),
                  label: const Text('Play'),
                ),
                ElevatedButton.icon(
                  onPressed: (_gameOver || _hasWon)
                      ? null
                      : _putToSleep,
                  icon: const Icon(Icons.bedtime),
                  label: const Text('Rest'),
                ),
                ElevatedButton.icon(
                  onPressed: _resetGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}