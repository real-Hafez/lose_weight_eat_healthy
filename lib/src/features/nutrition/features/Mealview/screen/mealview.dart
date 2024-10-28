import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    required this.Ingredients,
    required this.steps,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * .5,
            floating: false,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // Calculate the percentage of the collapsed app bar
                var appBarHeight =
                    MediaQuery.of(context).padding.top + kToolbarHeight;
                var percentCollapsed = (constraints.maxHeight - appBarHeight) /
                    (MediaQuery.of(context).size.height * .5 - appBarHeight);
                return FlexibleSpaceBar(
                  title: percentCollapsed <= 0.5 // Show title when collapsed
                      ? Text(
                          foodName,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      : null,
                  background: CachedNetworkImage(
                    imageUrl: foodImage,
                    fit: BoxFit.cover,
                  ),
                  collapseMode: CollapseMode.parallax,
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .02,
              ),
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: AutoSizeText(
                        foodName,
                        minFontSize: 20,
                        maxFontSize: 34,
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                        // textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'المعلومات الغذائية',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .03,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Nutrient Cards Section
                    Row(
                      children: [
                        Expanded(
                          child: NutrientCard(
                            icon: Icons.local_fire_department,
                            iconColor: Colors.red,
                            title: 'البروتين',
                            content: protein,
                            unit: 'جرام',
                          ),
                        ),
                        Expanded(
                          child: NutrientCard(
                            icon: Icons.local_fire_department,
                            iconColor: Colors.red,
                            title: 'السعرات الحرارية',
                            content: calories,
                            unit: 'السعرات الحرارية',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: NutrientCard(
                            icon: Icons.local_fire_department,
                            iconColor: Colors.red,
                            title: 'الدهون',
                            content: fat,
                            unit: 'غ',
                          ),
                        ),
                        Expanded(
                          child: NutrientCard(
                            icon: Icons.local_fire_department,
                            iconColor: Colors.red,
                            title: 'الكربوهيدرات',
                            content: carbs,
                            unit: 'غ',
                          ),
                        ),
                      ],
                    ), // Preparation time widget
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    _buildPreparationTime(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'المكونات',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    ListView.builder(
                        shrinkWrap:
                            true, // Allows ListView to take only the space it needs
                        physics:
                            NeverScrollableScrollPhysics(), // no inner scrolling
                        itemCount: Ingredients.length,
                        itemBuilder: (context, index) {
                          return Column(
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.sizeOf(context).height *
                                              .003),
                                  child: Text(
                                    Ingredients[index],
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              .02,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                if (index < Ingredients.length - 1)
                                  Divider(
                                    color: Colors.grey[400],
                                    thickness: 2.0,
                                  ),
                              ]);
                        }),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'خطوات التحضير',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .04,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    ListView.builder(
                        shrinkWrap:
                            true, // Allows ListView to take only the space it needs
                        physics:
                            NeverScrollableScrollPhysics(), // no inner scrolling
                        itemCount: steps.length,
                        itemBuilder: (context, index) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.sizeOf(context).height *
                                              .003),
                                  child: Text(
                                    steps[index],
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              .02,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                if (index < steps.length - 1)
                                  Divider(
                                    color: Colors.grey[400],
                                    thickness: 2.0,
                                  ),
                              ]);
                        }),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreparationTime(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.height * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(30),
      ),
      // child: Align(
      // alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            color: Colors.white,
            size: MediaQuery.of(context).size.height * 0.04,
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          AutoSizeText(
            'وقت التحضير: ٢٠ دقيقة',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.0255,
              color: Colors.white,
            ),
            maxLines: 1,
            maxFontSize: 28,
            minFontSize: 22,
          ),
        ],
      ),
      // ),
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
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: const Color(0xFFF5EDEA),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: MediaQuery.of(context).size.height * .04,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .02),
            Text(
              title,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * .025,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            AutoSizeText(
              '$unit $content ',
              maxFontSize: 32,
              minFontSize: 14,
              maxLines: 1,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * .02,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
