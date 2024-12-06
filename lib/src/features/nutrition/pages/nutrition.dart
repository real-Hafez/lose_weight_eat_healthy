import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Week_page/pages/Week_Page.dart';

import '../features/Day_page/Pages/Dayview.dart';

class Nutrition extends StatefulWidget {
  // final FoodService_breakfast foodService = FoodService();

  const Nutrition({super.key});

  @override
  _NutritionState createState() => _NutritionState();
}

class _NutritionState extends State<Nutrition> {
  // Define the options for the toggle buttons
  final List<String> options = [
    '${S().day}',
    '${S().week}',
    '${S().shoppinglist}'
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(options.length, (index) {
              return GestureDetector(
                onTap: () {
                  // When an item is tapped, update the selected index
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child:
                    buildCategoryItem(options[index], index == selectedIndex),
              );
            }),
          ),
        ),
        // Content separator
        const SizedBox(height: 25),
        buildContent(),
      ],
    );
  }

  Widget buildCategoryItem(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          AutoSizeText(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          Container(
            height: 2.0,
            width: 60.0,
            color: isSelected ? Colors.red : Colors.transparent,
          ),
        ],
      ),
    );
  }

  // Widget to build content that changes based on the selected tab
  Widget buildContent() {
    switch (selectedIndex) {
      case 0:
        return const Expanded(child: Dayview());
      case 1:
        return const Expanded(child: WeekView());
      case 2:
        return const ShoppingListView();
      default:
        return Container();
    }
  }
}

class ShoppingListView extends StatelessWidget {
  const ShoppingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Shopping List view content');
  }
}
