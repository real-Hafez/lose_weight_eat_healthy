import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lose_weight_eat_healthy/src/features/Home/widgets/calender_for_training_water.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/WaterIntakeWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Water extends StatefulWidget {
  const Water({super.key});

  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  String? _savedUnit;
  double _waterNeeded = 6000.0;
  double _currentIntake = 0.0;
  static const platform =
      MethodChannel('com.example.lose_weight_eat_healthy/widget');
  final Set<DateTime> _goalReachedDays = {};
  final Map<DateTime, bool> _goalCompletionStatus = {};
  DateTime _lastResetDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
    _setupWidgetListener();
    get_water_need_and_unit();
    // _checkPreviousDayGoal();
    _resetWaterIntakeIfNewDay();
    // _startDailyResetTimer();
  }
Future<void> _checkPreviousDayGoal() async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final formattedYesterday =
        "${yesterday.year}-${yesterday.month}-${yesterday.day}";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, bool> goalStatusMap = Map.fromEntries(
        (prefs.getStringList('goal_status_dates') ?? []).map((e) {
      final parts = e.split(':');
      return MapEntry(parts[0], parts[1] == 'true');
    }));

    if (!goalStatusMap.containsKey(formattedYesterday)) {
      goalStatusMap[formattedYesterday] = false;
      await prefs.setStringList('goal_status_dates',
          goalStatusMap.entries.map((e) => "${e.key}:${e.value}").toList());
    }

    _loadGoalCompletionStatus();
  }
  Future<void> _resetWaterIntakeIfNewDay() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    print('Checking if a new day: Today is $today');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastResetDateString = prefs.getString('last_reset_date');
    print('Last reset date from preferences: $lastResetDateString');

    if (lastResetDateString != null) {
      _lastResetDate = DateTime.parse(lastResetDateString);
    } else {
      // If there's no stored date, consider it's a new day and reset the intake.
      _lastResetDate = today
          .subtract(const Duration(days: 1)); // Force reset on the first run
      await prefs.setString('last_reset_date', today.toIso8601String());
    }

    if (today.isAfter(_lastResetDate)) {
      setState(() {
        _currentIntake = 0.0;
        _lastResetDate = today;
      });
      await prefs.setDouble('water_drunk', 0.0);
      await prefs.setString('last_reset_date', today.toIso8601String());

      // Update the widget and notify of the reset
      _updateWidget();
      print('New day detected. Water intake reset to 0.');
    }
  }

  void _handleGoalStatus(bool reached) async {
    final today = DateTime.now();
    final formattedDate = "${today.year}-${today.month}-${today.day}";
    print('Goal status for $formattedDate: $reached');

    setState(() {
      _goalCompletionStatus[DateTime(today.year, today.month, today.day)] =
          reached;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, bool> goalStatusMap = Map.fromEntries(
        (prefs.getStringList('goal_status_dates') ?? []).map((e) {
      final parts = e.split(':');
      return MapEntry(parts[0], parts[1] == 'true');
    }));

    goalStatusMap[formattedDate] = reached;

    await prefs.setStringList('goal_status_dates',
        goalStatusMap.entries.map((e) => "${e.key}:${e.value}").toList());
  }

  Future<void> get_water_need_and_unit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? value = prefs.getDouble('water_needed');
    String? waterUnit = prefs.getString('water_unit');
    print('Retrieved water needs: $value, unit: $waterUnit');
    if (value != null) {
      setState(() {
        _waterNeeded = value;
        _savedUnit = waterUnit ?? 'mL';
      });
      print('Water needed is $_waterNeeded $_savedUnit');
    } else {
      print('No value found for the key.');
    }
  }

  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedUnit = prefs.getString('water_unit') ?? 'mL';
      _currentIntake = prefs.getDouble('water_drunk') ?? 0.0;
    });
    print(
        'Saved preferences loaded: $_savedUnit, water drunk: $_currentIntake');
    await _resetWaterIntakeIfNewDay();
    // _loadGoalCompletionDays();
    _updateWidget();
  }

  void _setupWidgetListener() {
    platform.setMethodCallHandler((call) async {
      print('Platform method call: ${call.method}');
      if (call.method == 'updateAppState') {
        final waterDrunkInMl = call.arguments as double;
        setState(() {
          _currentIntake = waterDrunkInMl;
        });
        print('Updated app state with water drunk: $_currentIntake');
        _saveWaterIntake();
      }
    });
  }

  Future<void> _updateWidget() async {
    try {
      await platform.invokeMethod('updateWidget', {
        'water': _waterNeeded,
        'water_drunk': _currentIntake,
        'unit': _savedUnit,
      });
      print(
          'Widget updated with water needed: $_waterNeeded, water drunk: $_currentIntake');
    } on PlatformException catch (e) {
      print("Failed to update widget: '${e.message}'");
    }
  }

  Future<void> _saveWaterIntake() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('water_drunk', _currentIntake);
    print('Water intake saved: $_currentIntake');
    _updateWidget();
  }

  @override
  Widget build(BuildContext context) {
    if (_savedUnit == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            WaterIntakeWidget(
              initialIntake: _currentIntake,
              totalTarget: _waterNeeded,
              unit: _savedUnit!,
              onIntakeChange: (newIntake) {
                setState(() {
                  _currentIntake = newIntake;
                  if (_currentIntake >= _waterNeeded) {
                    _handleGoalStatus(true);
                    print('Goal reached: $_currentIntake mL');
                  } else {
                    _handleGoalStatus(false);
                    print('Goal not reached: $_currentIntake mL');
                  }
                });
                _saveWaterIntake();
              },
            ),
            calender_for_training_water(
              goalCompletionStatus: _goalCompletionStatus,
            ),
            const SizedBox(
              height: 45,
            ),
            const History(),
            const SizedBox(
              height: 102,
            ),
          ],
        ),
      ),
    );
  }
}

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'History',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * .06,
          ),
        ),
        Row(
          children: [
            Text(
              '11-9-2024',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * .03,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .03,
            ),
            Icon(
              Icons.water_drop_outlined,
              size: MediaQuery.of(context).size.height * .03,
            ),
            Text(
              'Water',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * .03,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .1,
            ),
            Text(
              '300 ml',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * .03,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
