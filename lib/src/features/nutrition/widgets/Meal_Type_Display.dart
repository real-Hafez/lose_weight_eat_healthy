import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _toggleComplete() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
    widget.onToggleMinimize();
    if (_isCompleted) {
      _confettiController
          .play(); // Trigger confetti when meal is marked as complete
    }
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
              color: _isCompleted
                  ? Colors.blue.withOpacity(0.2)
                  : Colors.transparent,
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
            colors: [Colors.blue, Colors.green, Colors.purple, Colors.orange],
          ),
        ),
      ],
    );
  }
}
