import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';
import 'package:shimmer/shimmer.dart';

class CalendarWidgetWeek extends StatefulWidget {
  const CalendarWidgetWeek({Key? key}) : super(key: key);

  @override
  _CalendarWidgetWeekState createState() => _CalendarWidgetWeekState();
}

class _CalendarWidgetWeekState extends State<CalendarWidgetWeek> {
  late DateTime focusedDay;
  late DateTime selectedDay;
  late List<DateTime> weekDates;

  @override
  void initState() {
    super.initState();
    focusedDay = DateTime.now();
    selectedDay = focusedDay;
    weekDates = _getWeekFromSaturdayToFriday(focusedDay);
  }

  List<DateTime> _getWeekFromSaturdayToFriday(DateTime date) {
    int differenceFromSaturday = date.weekday % 7;
    DateTime saturday = date.subtract(Duration(days: differenceFromSaturday));
    return List.generate(7, (i) => saturday.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // const Text(
            //   'Weekly Meal Plan',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 0),

            const Row(
              children: [
                SizedBox(width: 80),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      'Breakfast',
                      maxLines: 1,
                      maxFontSize: 22,
                      minFontSize: 12,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      'Lunch',
                      maxLines: 1,
                      maxFontSize: 22,
                      minFontSize: 12,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      'Dinner',
                      maxLines: 1,
                      maxFontSize: 22,
                      minFontSize: 12,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: weekDates.length,
                    itemBuilder: (context, index) {
                      final date = weekDates[index];
                      return DayCell(
                        date: date,
                        isSelected: isSameDay(selectedDay, date),
                        onTap: () {
                          setState(() {
                            selectedDay = date;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: weekDates.length,
                    itemBuilder: (context, index) {
                      final date = weekDates[index];
                      return MealRow(date: date);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const DayCell({
    super.key,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isToday = isSameDay(date, DateTime.now());

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.blue, width: 2)
              : Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('EEE').format(date),
                style: TextStyle(
                  fontWeight: isToday || isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isToday || isSelected ? Colors.blue : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('d').format(date),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isToday || isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isToday || isSelected ? Colors.blue : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealRow extends StatelessWidget {
  final DateTime date;

  const MealRow({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: MealWidget(
              mealType: 'Breakfast',
              selectedDay: date,
              fetchFoodData:
                  FoodService_breakfast().getFoods, //  service for breakfast
            ),
          ),
          const VerticalDivider(color: Colors.grey, thickness: 1),
          Expanded(
            child: MealWidget(
              mealType: 'Lunch',
              selectedDay: date,
              fetchFoodData: FoodService_launch()
                  .getFoods, //  service for lunch may be need edit so rememper
            ),
          ),
          const VerticalDivider(color: Colors.grey, thickness: 1),
          Expanded(
            child: MealWidget(
              mealType: 'Dinner',
              selectedDay: date,
              fetchFoodData:
                  FoodService_Dinner().getFoods, //  service for dinner
            ),
          ),
        ],
      ),
    );
  }
}

class MealWidget extends StatelessWidget {
  final String mealType;
  final DateTime selectedDay;
  final Future<List<Map<String, dynamic>>> Function() fetchFoodData;

  const MealWidget({
    Key? key,
    required this.mealType,
    required this.selectedDay,
    required this.fetchFoodData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchFoodData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerLoading();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            children: [
              Image.network('https://via.placeholder.com/120', height: 100),
            ],
          );
        } else {
          var food = snapshot.data![0];
          return CachedNetworkImage(
            imageUrl: food['food_Image'] ?? 'https://via.placeholder.com/120',
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const ShimmerLoading(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
        }
      },
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 100,
        width: double.infinity,
        color: Colors.grey,
      ),
    );
  }
}

bool isSameDay(DateTime day1, DateTime day2) {
  return day1.year == day2.year &&
      day1.month == day2.month &&
      day1.day == day2.day;
}
