import 'package:flutter/material.dart';

class FavFood extends StatelessWidget {
  const FavFood(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        Fav_food_card(
          text: "fdsff",
        ),
        Fav_food_card(
          text: "fdsff",
        ),
        Fav_food_card(
          text: "fdsff",
        ),
        Fav_food_card(
          text: "fdsff",
        ),
        Fav_food_card(
          text: "fdsff",
        ),
        Fav_food_card(
          text: "fdsff",
        ),
        Fav_food_card(
          text: "fds",
        ),
      ],
    );
  }
}

class Fav_food_card extends StatelessWidget {
  const Fav_food_card({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.height * .05,
        ),
      ),
    );
  }
}
