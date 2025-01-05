import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Meal_Type_Display extends StatefulWidget {
  const Meal_Type_Display({
    super.key,
    required this.food,
    required this.minmize,
    required this.onToggleMinimize,
  });

  final String food;
  final bool minmize;
  final VoidCallback onToggleMinimize;

  @override
  _Meal_Type_DisplayState createState() => _Meal_Type_DisplayState();
}

class _Meal_Type_DisplayState extends State<Meal_Type_Display> {
  bool _isCompleted = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _checkAndResetState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _checkAndResetState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String today = DateTime.now().toIso8601String().split('T')[0];
    String? lastResetDate = prefs.getString('lastResetDate');

    if (lastResetDate != today) {
      await _resetMealState();
      await prefs.setString('lastResetDate', today);
    } else {
      await _loadCompletionState();
    }
  }

  Future<void> _resetMealState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('${widget.food}_completed');
    setState(() {
      _isCompleted = false;
    });
  }

  Future<void> _loadCompletionState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCompleted = prefs.getBool('${widget.food}_completed') ?? false;
    });
  }

  void _toggleComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCompleted = !_isCompleted;
    });

    if (_isCompleted) {
      widget.onToggleMinimize(); // Minimize meal
      _confettiController.play();
    }

    await prefs.setBool('${widget.food}_completed', _isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: _toggleComplete,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: widget.minmize
                  ? Colors.transparent
                  : (_isCompleted
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.food,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height * .04,
                    fontWeight:
                        _isCompleted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Icon(
                  FontAwesomeIcons.check,
                  color: _isCompleted ? Colors.blue : Colors.white,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            emissionFrequency: 0.6,
            numberOfParticles: 20,
            maxBlastForce: 20,
            minBlastForce: 5,
            colors: const [
              Colors.blue,
              Colors.green,
              Colors.purple,
              Colors.orange
            ],
          ),
        ),
      ],
    );
  }
}
