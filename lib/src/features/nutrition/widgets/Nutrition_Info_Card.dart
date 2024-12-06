import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Mealview/screen/mealview.dart';
import 'package:shimmer/shimmer.dart'; // For shimmer effect

class NutritionInfoCard extends StatelessWidget {
  const NutritionInfoCard({
    super.key,
    required this.foodName,
    required this.foodImage,
    required this.calories,
    required this.weight,
    required this.fat,
    required this.carbs,
    required this.protein,
    required this.Ingredients,
    required this.steps,
    required this.tips,
    required this.isCompleted,
    required this.animationController,
    required this.meal_id,
  });

  final String foodName;
  final String foodImage;
  final double calories;
  final double weight;
  final double fat;
  final double carbs;
  final double protein;
  final List<String> Ingredients;
  final List<String> steps;
  final List<Map<String, dynamic>> tips;
  final bool isCompleted;
  final AnimationController animationController;
  final int meal_id;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        // Wrap the entire card in a ScaleTransition
        return ScaleTransition(
          scale: isCompleted
              ? Tween(begin: 1.0, end: 1.1).animate(CurvedAnimation(
                  parent: animationController, curve: Curves.easeInOut))
              : const AlwaysStoppedAnimation(1.0), // Static when not completed
          child: GestureDetector(
            onTap: () {
              print('meal id is $meal_id');
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Mealview(
                    tips: tips,
                    steps: steps,
                    Ingredients: Ingredients,
                    calories: calories,
                    carbs: carbs,
                    fat: fat,
                    foodName: foodName,
                    protein: protein,
                    weight: weight,
                    foodImage: foodImage,
                  );
                },
              ));
            },
            child: Card(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food image and details
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: foodImage,
                            width: screenWidth * 0.37, // Adaptive image width
                            height: screenWidth * 0.37, // Adaptive image height
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                _buildShimmerEffect(),
                            errorWidget: (context, url, error) =>
                                _buildErrorWidget(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                foodName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$weight g',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Nutrient Information
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNutrientCard(
                          FontAwesomeIcons.fire,
                          '$calories cal',
                          'Calories',
                          Colors.deepOrangeAccent,
                        ),
                        _buildNutrientCard(
                          FontAwesomeIcons.drumstickBite,
                          '$protein g',
                          'Protein',
                          Colors.lightGreen,
                        ),
                        _buildNutrientCard(
                          FontAwesomeIcons.breadSlice,
                          '$carbs g',
                          'Carbs',
                          Colors.lightBlueAccent,
                        ),
                        _buildNutrientCard(
                          FontAwesomeIcons.cheese,
                          '$fat g',
                          'Fat',
                          Colors.amberAccent,
                        ),
                      ],
                    ),
                    if (isCompleted)
                      Center(
                        child: ScaleTransition(
                          scale: Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 80,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Shimmer effect as a loading placeholder
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
    );
  }

  // Custom error widget for image loading failure
  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      height: double.infinity,
      child: const Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 40,
      ),
    );
  }

  // Nutrient card builder
  Widget _buildNutrientCard(
      IconData icon, String amount, String label, Color color) {
    return Column(
      children: [
        FaIcon(
          icon,
          size: 28,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          amount,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
