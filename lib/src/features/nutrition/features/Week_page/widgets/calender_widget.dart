import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';

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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column for dates to show the whole week
              Column(
                children: weekDates.map((date) {
                  return DayCell(
                    date: date,
                    isSelected: isSameDay(selectedDay, date),
                    onTap: () {
                      setState(() {
                        selectedDay = date;
                      });
                    },
                  );
                }).toList(),
              ),

              Expanded(
                child: Column(
                  children: [
                    // fore  meal labels like breakfast .... etc
                    const Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Breakfast',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                        VerticalDivider(color: Colors.grey, thickness: 1.5),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Lunch',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                        VerticalDivider(color: Colors.grey, thickness: 1.5),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Dinner',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Meal images for the week
                    ...weekDates.map((date) {
                      return MealRow(date: date);
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const DayCell({
    Key? key,
    required this.date,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isToday = isSameDay(date, DateTime.now());

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: 80,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
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
                  color: isToday || isSelected ? Colors.blue : Colors.grey,
                ),
              ),
              Text(
                DateFormat('d').format(date),
                style: TextStyle(
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
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: MealWidget(
              mealType: 'Breakfast',
              selectedDay: date,
              fetchFoodData: FoodService_breakfast().getFoods,
            ),
          ),
          const VerticalDivider(color: Colors.grey, thickness: 1.5),
          Expanded(
            child: MealWidget(
              mealType: 'Lunch',
              selectedDay: date,
              fetchFoodData: FoodService_launch().getFoods,
            ),
          ),
          const VerticalDivider(color: Colors.grey, thickness: 1.5),
          Expanded(
            child: MealWidget(
              mealType: 'Dinner',
              selectedDay: date,
              fetchFoodData: FoodService_Dinner().getFoods,
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
              Image.network('https://via.placeholder.com/120', height: 120),
            ],
          );
        } else {
          var food = snapshot.data![0];
          return Container(
            height: 120,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: food['food_Image'] ?? 'https://via.placeholder.com/120',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const ShimmerLoading(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
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
        height: 120,
        width: double.infinity,
        color: Colors.grey,
      ),
    );
  }
}

// Helper function to compare if two days are the same
bool isSameDay(DateTime day1, DateTime day2) {
  return day1.year == day2.year &&
      day1.month == day2.month &&
      day1.day == day2.day;
}
