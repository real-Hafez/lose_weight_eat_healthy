// import 'package:flutter/material.dart';
// import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';

// class MealTypeDisplay extends StatefulWidget {
//   final Map<String, dynamic> meal;

//   const MealTypeDisplay({Key? key, required this.meal}) : super(key: key);

//   @override
//   _MealTypeDisplayState createState() => _MealTypeDisplayState();
// }

// class _MealTypeDisplayState extends State<MealTypeDisplay> {
//   @override
//   Widget build(BuildContext context) {
//     final String foodName = widget.meal['food_Name_Arabic'] ?? 'Unknown Food';
//     final String foodImage =
//         widget.meal['food_Image'] ?? 'https://via.placeholder.com/150';

//     final int calories = (widget.meal['calories'] ?? 0).toInt();
//     final int weight = (widget.meal['weight'] ?? 0).toInt();
//     final int fat = (widget.meal['fat'] ?? 0).toInt();
//     final int carbs = (widget.meal['carbs'] ?? 0).toInt();
//     final int protein = (widget.meal['protein'] ?? 0).toInt();

//     final List<String> ingredients =
//         List<String>.from(widget.meal['ingredients_Ar'] ?? []);
//     final List<String> steps =
//         List<String>.from(widget.meal['preparation_steps'] ?? []);
//     final List<Map<String, dynamic>> tips =
//         List<Map<String, dynamic>>.from(widget.meal['tips'] ?? []);

//     return Column(
//       children: [
//         ListTile(
//           title: Text(widget.meal['mealType'] ?? 'Unknown Meal'),
//           trailing: Text('$calories cal'),
//         ),
//         NutritionInfoCard(
//           foodName: foodName,
//           foodImage: foodImage,
//           calories: calories,
//           weight: weight,
//           fat: fat,
//           carbs: carbs,
//           protein: protein,
//           Ingredients: ingredients,
//           steps: steps,
//           tips: tips,
//           isCompleted: false,
//           meal_id: widget.meal['meal_id'] ?? 0,
//         ),
//       ],
//     );
//   }
// }
