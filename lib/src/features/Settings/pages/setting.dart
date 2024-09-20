import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> _units = ['L', 'mL', 'US oz'];
  int _selectedIndex = 0;
  static const platform =
      MethodChannel('com.example.lose_weight_eat_healthy/widget');

  @override
  void initState() {
    super.initState();
    _loadSelectedUnit();
  }

  Future<void> _loadSelectedUnit() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUnit = prefs.getString('water_unit') ?? 'mL';
    setState(() {
      _selectedIndex = _units.indexOf(savedUnit);
    });
  }

  Future<void> _saveSelectedUnit(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedUnit = _units[index];

    // Retrieve the current values
    final currentWaterNeeded = prefs.getDouble('water_needed') ?? 3000.0;
    final currentWaterDrunk = prefs.getDouble('water_drunk') ?? 0.0;

    // Convert values to the new unit
    final currentUnit = prefs.getString('water_unit') ?? 'mL';
    final newWaterNeeded =
        _convertToUnit(currentWaterNeeded, currentUnit, selectedUnit);
    final newWaterDrunk =
        _convertToUnit(currentWaterDrunk, currentUnit, selectedUnit);

    // Save new values and unit
    await prefs.setDouble('water_needed', newWaterNeeded);
    await prefs.setDouble('water_drunk', newWaterDrunk);
    await prefs.setString('water_unit', selectedUnit);

    _updateWidget(newWaterNeeded, newWaterDrunk, selectedUnit);
  }

  double _convertToUnit(double value, String fromUnit, String toUnit) {
    switch (toUnit) {
      case 'L':
        return _convertToL(value, fromUnit);
      case 'US oz':
        return _convertToOz(value, fromUnit);
      default:
        return _convertToMl(value, fromUnit);
    }
  }

  double _convertToL(double value, String fromUnit) {
    switch (fromUnit) {
      case 'mL':
        return value / 1000.0;
      case 'US oz':
        return value * 0.0295735;
      default:
        return value;
    }
  }

  double _convertToOz(double value, String fromUnit) {
    switch (fromUnit) {
      case 'mL':
        return value * 0.033814;
      case 'L':
        return value * 33.814;
      default:
        return value;
    }
  }

  double _convertToMl(double value, String fromUnit) {
    switch (fromUnit) {
      case 'L':
        return value * 1000.0;
      case 'US oz':
        return value / 0.033814;
      default:
        return value;
    }
  }

  Future<void> _updateWidget(
      double waterNeeded, double waterDrunk, String unit) async {
    try {
      await platform.invokeMethod('updateWidget', {
        'water': waterNeeded,
        'water_drunk': waterDrunk,
        'unit': unit,
      });
    } on PlatformException catch (e) {
      print("Failed to update widget: '${e.message}'");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose your preferred unit:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ToggleButtons(
              isSelected: List.generate(
                _units.length,
                (index) => index == _selectedIndex,
              ),
              onPressed: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                _saveSelectedUnit(index);
              },
              children: _units
                  .map((unit) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(unit),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
