import 'dart:ffi';

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
  });

  final String foodName;
  final String foodImage;
  final int calories;
  final int weight;
  final int fat;
  final int carbs;
  final int protein;
  final List<String> Ingredients;
  final List<String> steps;
  final List<Map<String, dynamic>> tips;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        return GestureDetector(
          onTap: () {
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
                          placeholder: (context, url) => _buildShimmerEffect(),
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
                ],
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

    //  Card(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(12),
    //   ),
    //   elevation: 4,
    //   child: Padding(
    //     padding: const EdgeInsets.all(12),
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         ClipRRect(
    //             borderRadius: BorderRadius.circular(10),
    //             child:
    //                 //  Image.network(
    //                 //   foodImage,
    //                 //   width: screenWidth * 0.25,
    //                 //   height: screenWidth * 0.40,
    //                 //   fit: BoxFit.fill,
    //                 // ),
    //                 CachedNetworkImage(
    //               imageUrl: foodImage,
    //               width: screenWidth * 0.40,
    //               height: screenWidth * 0.50,
    //               placeholder: (context, url) => CircularProgressIndicator(),
    //               errorWidget: (context, url, error) => Icon(Icons.error),
    //             )),
    //         const SizedBox(width: 10),
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 foodName,
    //                 style: const TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   fontSize: 16,
    //                 ),
    //               ),
    //               Text('$weight gr', style: TextStyle(color: Colors.grey[600])),
    //             ],
    //           ),
    //         ),
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: [
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.end,
    //                 children: [
    //                   const Icon(Icons.local_fire_department,
    //                       color: Colors.red),
    //                   const SizedBox(width: 4),
    //                   Text(
    //                     '$calories cal',
    //                     style: const TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: 16,
    //                       color: Colors.red,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               const SizedBox(height: 10),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   _buildNutrientInfo(
    //                     FontAwesomeIcons.pizzaSlice,
    //                     '$fat gr',
    //                     'Fat',
    //                   ),
    //                   _buildNutrientInfo(
    //                     FontAwesomeIcons.breadSlice,
    //                     '$carbs gr',
    //                     'Carbs',
    //                   ),
    //                   _buildNutrientInfo(
    //                     FontAwesomeIcons.fish,
    //                     '$protein gr',
    //                     'Protein',
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
