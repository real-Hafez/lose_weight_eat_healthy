import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Week_page/widgets/ShimmerLoading.dart';

class MealDetailCard extends StatefulWidget {
  final String mealType;
  final DateTime selectedDay;
  final Future<List<Map<String, dynamic>>> Function() fetchFoodData;
  final bool isExpanded;

  const MealDetailCard({
    super.key,
    required this.mealType,
    required this.selectedDay,
    required this.fetchFoodData,
    this.isExpanded = false,
  });

  @override
  _MealDetailCardState createState() => _MealDetailCardState();
}

class _MealDetailCardState extends State<MealDetailCard> {
  List<Map<String, dynamic>>? cachedFoodData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (cachedFoodData == null) {
      cachedFoodData = await widget.fetchFoodData();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cachedFoodData == null) {
      return const ShimmerLoading();
    }

    if (cachedFoodData!.isEmpty) {
      return Column(
        children: [
          Image.network('https://via.placeholder.com/120', height: 100),
        ],
      );
    }

    int dayIndex = widget.selectedDay.difference(DateTime(2024, 1, 1)).inDays;
    int mealIndex = dayIndex % cachedFoodData!.length;
    var food = cachedFoodData![mealIndex];

    print("Displaying meal ID: ${food['id']} on day $dayIndex");
    print("Meal Details: $food");

    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: food['food_Image'] ?? 'https://via.placeholder.com/120',
          height: widget.isExpanded ? 100 : 95,
          width: double.infinity,
          fit: BoxFit.fill,
          placeholder: (context, url) => const ShimmerLoading(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        if (widget.isExpanded) ...[
          AutoSizeText(
            '${food['food_Name_Arabic']}',
            maxLines: 2,
            wrapWords: true,
            overflow: TextOverflow.ellipsis,
            minFontSize: 16,
            maxFontSize: 22,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Icon(Icons.local_fire_department, size: 18),
                  AutoSizeText(
                    '${food['calories']}',
                    maxLines: 1,
                    minFontSize: 8,
                    maxFontSize: 22,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.fitness_center, size: 18),
                  AutoSizeText(
                    '${food['protein']}g',
                    maxLines: 1,
                    minFontSize: 8,
                    maxFontSize: 22,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.rice_bowl, size: 18),
                  AutoSizeText(
                    '${food['carbs']}g',
                    maxLines: 1,
                    minFontSize: 8,
                    maxFontSize: 22,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }
}
