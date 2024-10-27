import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Mealview extends StatelessWidget {
  Mealview({
    super.key,
    required this.foodImage,
    required this.foodName,
    required this.calories,
    required this.weight,
    required this.fat,
    required this.carbs,
    required this.protein,
  });
  final String foodName;
  final String foodImage;
  final int calories;
  final int weight;
  final int fat;
  final int carbs;
  final int protein;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * .5,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: foodImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(
                    foodName,
                    minFontSize: 20,
                    maxFontSize: 34,
                    maxLines: 3,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const Text(
                    '١٠ دقائق',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.05,
                  ),
                  Text(
                    'المعلومات الغذائية',
                    style: TextStyle(
                      fontSize: MediaQuery.sizeOf(context).height * .03,
                      color: Colors.white,
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal, // Enable horizontal scrolling
                          child: Row(
                            children: [
                              NutrientCard(
                                icon: Icons.local_fire_department,
                                iconColor: Colors.red,
                                title: 'دهون',
                                content: 600,
                                unit: 'غ', // Use 'غ' for grams
                              ),
                              NutrientCard(
                                icon: Icons.local_fire_department,
                                iconColor: Colors.red,
                                title: 'كالوري',
                                content: 350, // Format in Arabic
                                unit: 'كال', // Change to 'كال' for consistency
                              ),
                              NutrientCard(
                                icon: Icons.local_fire_department,
                                iconColor: Colors.red,
                                title: 'بروتين',
                                content: 450,
                                unit: 'غ', // Use 'غ' for grams
                              ),
                              NutrientCard(
                                icon: Icons.local_fire_department,
                                iconColor: Colors.red,
                                title: 'كارب',
                                content: 550,
                                unit: 'غ', // Use 'غ' for grams
                              ),
                              NutrientCard(
                                icon: Icons.local_fire_department,
                                iconColor: Colors.red,
                                title: 'بروتين',
                                content: 450,
                                unit: 'غ', // Use 'غ' for grams
                              ),
                              NutrientCard(
                                icon: Icons.local_fire_department,
                                iconColor: Colors.red,
                                title: 'كالوري',
                                content: 350, // Format in Arabic
                                unit: 'كال', // Change to 'كال' for consistency
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NutrientCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final int content;
  final String unit;

  const NutrientCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0, // Adds shadow to the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: const Color(0xFFF5EDEA), // Light background color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.end, // Align everything to the right
          children: [
            Icon(
              icon,
              color: iconColor,
              size: MediaQuery.sizeOf(context).height * .04,
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * .04),
            Text(
              title,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).height * .03,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * .01),
            Text(
              '$content ',
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).height * .04,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
