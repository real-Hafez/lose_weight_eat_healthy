import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/MealCompletionState.dart';

class Meal_Type_Display extends StatefulWidget {
  const Meal_Type_Display({
    super.key,
    required this.food,
    required this.minmize,
    required this.onToggleMinimize,
    required this.mealCalories, // Add this property
  });

  final String food;
  final bool minmize;
  final VoidCallback onToggleMinimize;
  final double mealCalories; // Add this property

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
    if (widget.minmize) {
      // Meal was marked as completed, now unmark it
      String mealType = widget.food.toLowerCase();
      context.read<MealCompletionCubit>().uncompleteMeal(mealType);
    } else {
      // Play confetti animation and mark as completed
      _confettiController.play();
      String mealType = widget.food.toLowerCase();
      context
          .read<MealCompletionCubit>()
          .completeMeal(mealType, widget.mealCalories);
    }
    widget.onToggleMinimize(); // Toggle minimize state
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
