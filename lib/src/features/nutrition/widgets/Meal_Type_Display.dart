import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

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

  void _handleTap() {
    setState(() {
      if (!widget.minmize) {
        // Play confetti animation only when minimizing
        _confettiController.play();
      }
      widget.onToggleMinimize(); // Toggle minimize state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: _handleTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: widget.minmize
                  ? Colors.blue.withOpacity(0.4)
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  widget.minmize ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.white,
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
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange
            ],
          ),
        ),
      ],
    );
  }
}
