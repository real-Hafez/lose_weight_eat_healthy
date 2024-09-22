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

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
    _setupWidgetListener();
    get_water_need_and_unit();
    _checkPreviousDayGoal();
  }

  void _handleGoalStatus(bool reached) async {
    final today = DateTime.now();
    final formattedDate = "${today.year}-${today.month}-${today.day}";

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

  Future<void> _loadGoalCompletionDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> goalReachedDates =
        prefs.getStringList('goal_reached_dates') ?? [];

    setState(() {
      _goalReachedDays.clear();
      for (String dateStr in goalReachedDates) {
        final parts = dateStr.split("-");
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        _goalReachedDays.add(DateTime(year, month, day));
      }
    });
  }

  Future<void> _loadGoalCompletionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> goalStatusDates =
        prefs.getStringList('goal_status_dates') ?? [];

    setState(() {
      _goalCompletionStatus.clear();
      for (String dateStr in goalStatusDates) {
        final parts = dateStr.split(":");
        final dateParts = parts[0].split("-");
        final year = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final day = int.parse(dateParts[2]);
        final status = parts[1] == 'true';
        _goalCompletionStatus[DateTime(year, month, day)] = status;
      }
    });
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

  Future<void> get_water_need_and_unit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? value = prefs.getDouble('water_needed');
    String? waterUnit = prefs.getString('water_unit');
    if (value != null) {
      setState(() {
        _waterNeeded = value;
        _savedUnit = waterUnit ?? 'mL';
      });
      print('Retrieved value: $_waterNeeded $_savedUnit');
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
    _loadGoalCompletionDays(); // Load goal completion data
    _updateWidget();
  }

  void _setupWidgetListener() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'updateAppState') {
        final waterDrunkInMl = call.arguments as double;
        setState(() {
          _currentIntake = waterDrunkInMl;
        });
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
    } on PlatformException catch (e) {
      print("Failed to update widget: '${e.message}'");
    }
  }

  Future<void> _saveWaterIntake() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('water_drunk', _currentIntake);
    _updateWidget();
  }

  void _handleUnitChange(String newUnit) async {
    if (_savedUnit != newUnit) {
      final convertedIntake =
          _convertWaterIntake(_currentIntake, _savedUnit!, newUnit);
      final convertedNeeded =
          _convertWaterIntake(_waterNeeded, _savedUnit!, newUnit);

      setState(() {
        _currentIntake = convertedIntake;
        _waterNeeded = convertedNeeded;
        _savedUnit = newUnit;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('water_unit', newUnit);
      await prefs.setDouble('water_drunk', _currentIntake);
      await prefs.setDouble('water_needed', _waterNeeded);

      _updateWidget();
    }
  }

  double _convertWaterIntake(double amount, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return amount;

    double mlAmount;
    switch (fromUnit) {
      case 'L':
        mlAmount = amount * 1000;
        break;
      case 'US oz':
        mlAmount = amount * 29.5735;
        break;
      default: // mL
        mlAmount = amount;
    }

    switch (toUnit) {
      case 'L':
        return mlAmount / 1000;
      case 'US oz':
        return mlAmount / 29.5735;
      default: // mL
        return mlAmount;
    }
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
                  } else {
                    _handleGoalStatus(false);
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
