import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidgetWeek extends StatefulWidget {
  const CalendarWidgetWeek({super.key});

  @override
  _CalendarViewWidgetState createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarWidgetWeek> {
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
          // Row for Calendar and FoodMenu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar section (left bar)
              Expanded(
                flex: 3,
                child: Column(
                  children: weekDates.map((date) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDay = date;
                          focusedDay = date;
                        });
                      },
                      child: DayCell(
                        date: date,
                        isSelected: isSameDay(selectedDay, date),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Expanded FoodMenu
              Expanded(
                flex: 10,
                child: FoodMenu(weekDates: weekDates),
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

  const DayCell({
    Key? key,
    required this.date,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isToday = isSameDay(date, DateTime.now());
    bool isTodayOrSelected = isToday || isSelected;

    return Container(
      height: 130,
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          children: [
            DayText(date: date, isTodayOrSelected: isTodayOrSelected),
            if (isTodayOrSelected) const TodayIndicator(),
          ],
        ),
      ),
    );
  }
}

class DayText extends StatelessWidget {
  final DateTime date;
  final bool isTodayOrSelected;

  const DayText({
    Key? key,
    required this.date,
    required this.isTodayOrSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          DateFormat('EEE').format(date),
          style: TextStyle(
            fontWeight: isTodayOrSelected ? FontWeight.w900 : FontWeight.w100,
            color: isTodayOrSelected ? Colors.blue : Colors.grey,
          ),
        ),
        Text(
          DateFormat('d').format(date),
          style: TextStyle(
            fontWeight: isTodayOrSelected ? FontWeight.w900 : FontWeight.w100,
            color: isTodayOrSelected ? Colors.blue : Colors.white,
          ),
        ),
      ],
    );
  }
}

class TodayIndicator extends StatelessWidget {
  const TodayIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(left: 8),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
    );
  }
}

class FoodMenu extends StatelessWidget {
  final List<DateTime> weekDates;

  const FoodMenu({Key? key, required this.weekDates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Breakfast',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Lunch',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Dinner',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: weekDates.map((date) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MealWidget(
                        mealType: 'Breakfast',
                        selectedDay: date,
                        fetchFoodData: FoodService_breakfast().getFoods,
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 1.5,
                      color: Colors.red,
                    ),
                    Expanded(
                      child: MealWidget(
                        mealType: 'Lunch',
                        selectedDay: date,
                        fetchFoodData: FoodService_launch().getFoods,
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 1.5,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: MealWidget(
                        mealType: 'Dinner',
                        selectedDay: date,
                        fetchFoodData: FoodService_Dinner().getFoods,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    thickness: 1.5,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
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
          return Container(
            height: 120, // Match the height to avoid the cell-image mismatch
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: food['food_Image'] ?? 'https://via.placeholder.com/120',
              height: 120, // Ensure height consistency
              width: double.infinity,
              fit: BoxFit.cover, // Ensure the image covers the entire cell
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
