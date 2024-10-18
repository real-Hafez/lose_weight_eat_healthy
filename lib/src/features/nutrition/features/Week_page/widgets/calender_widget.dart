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
  late DateTime? expandedDay; // Track expanded day

  @override
  void initState() {
    super.initState();
    focusedDay = DateTime.now();
    selectedDay = focusedDay;
    expandedDay = selectedDay; // Default expanded to the selected day
    weekDates = _getWeekFromSaturdayToFriday(focusedDay);
  }

  List<DateTime> _getWeekFromSaturdayToFriday(DateTime date) {
    int differenceFromSaturday = date.weekday % 7;
    DateTime saturday = date.subtract(Duration(days: differenceFromSaturday));
    return List.generate(7, (i) => saturday.add(Duration(days: i)));
  }

  // Toggle expand or collapse
  void _toggleExpanded(DateTime date) {
    setState(() {
      if (expandedDay == date) {
        expandedDay = null; // Collapse if the same day is clicked again
      } else {
        expandedDay = date; // Expand the clicked day
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
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
                          final bool isExpanded =
                              expandedDay == date; // Check if expanded
                          return DayCell(
                            date: date,
                            isSelected: isSameDay(selectedDay, date),
                            isExpanded: isExpanded, // Pass expanded state
                            onTap: () {
                              setState(() {
                                selectedDay = date;
                                _toggleExpanded(date);
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
                          return MealRow(
                            date: date,
                            isExpanded: expandedDay ==
                                date, // Check if this date is expanded
                            onTapExpand: () =>
                                _toggleExpanded(date), // Toggle when tapped
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isExpanded; // Expanded state
  final VoidCallback onTap;

  const DayCell({
    Key? key,
    required this.date,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isToday = isSameDay(date, DateTime.now());

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height:
            isExpanded ? 220 : 100, // Match the expanded height of the MealRow
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
  final bool isExpanded;
  final VoidCallback onTapExpand;

  const MealRow({
    Key? key,
    required this.date,
    this.isExpanded = false,
    required this.onTapExpand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapExpand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isExpanded ? 220 : 100,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: MealWidget(
                mealType: 'Breakfast',
                selectedDay: date,
                fetchFoodData: FoodService_breakfast().getFoods,
                isExpanded: isExpanded,
              ),
            ),
            const VerticalDivider(color: Colors.grey, thickness: 1),
            Expanded(
              child: MealWidget(
                mealType: 'Lunch',
                selectedDay: date,
                fetchFoodData: FoodService_launch().getFoods,
                isExpanded: isExpanded,
              ),
            ),
            const VerticalDivider(color: Colors.grey, thickness: 1),
            Expanded(
              child: MealWidget(
                mealType: 'Dinner',
                selectedDay: date,
                fetchFoodData: FoodService_Dinner().getFoods,
                isExpanded: isExpanded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MealWidget extends StatefulWidget {
  final String mealType;
  final DateTime selectedDay;
  final Future<List<Map<String, dynamic>>> Function() fetchFoodData;
  final bool isExpanded;

  const MealWidget({
    Key? key,
    required this.mealType,
    required this.selectedDay,
    required this.fetchFoodData,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  _MealWidgetState createState() => _MealWidgetState();
}

class _MealWidgetState extends State<MealWidget> {
  List<Map<String, dynamic>>? cachedFoodData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Check if data is already cached
    if (cachedFoodData == null) {
      // Fetch data and cache it
      cachedFoodData = await widget.fetchFoodData();
      setState(() {}); // Trigger rebuild
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

    var food = cachedFoodData![0]; // Get the first food item
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
            'Name: ${food['food_Name']}',
            maxLines: 3,
            minFontSize: 10,
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
