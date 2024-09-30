import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Meal_Type_Display extends StatelessWidget {
  const Meal_Type_Display({super.key, required this.food});
  final String food;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              food,
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.height * .04,
              ),
            ),
            const Icon(FontAwesomeIcons.edit)
          ],
        ),
      ),
    );
  }
}
