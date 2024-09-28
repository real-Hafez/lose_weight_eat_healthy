import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
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

    final currentWaterNeeded = prefs.getDouble('water_needed') ?? 3000.0;
    final currentWaterDrunk = prefs.getDouble('water_drunk') ?? 0.0;

    final currentUnit = prefs.getString('water_unit') ?? 'mL';
    final newWaterNeeded =
        _convertToUnit(currentWaterNeeded, currentUnit, selectedUnit);
    final newWaterDrunk =
        _convertToUnit(currentWaterDrunk, currentUnit, selectedUnit);

    await prefs.setDouble('water_needed', newWaterNeeded);
    await prefs.setDouble('water_drunk', newWaterDrunk);
    context.read<WaterBloc>().updateWaterUnit(selectedUnit);

    await prefs.setString('water_unit', selectedUnit);

    _updateWidget(newWaterNeeded, newWaterDrunk, selectedUnit);
  }

  double _convertToUnit(double value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return value;

    double mlValue;
    switch (fromUnit) {
      case 'L':
        mlValue = value * 1000;
        break;
      case 'US oz':
        mlValue = value * 29.5735;
        break;
      default: 
        mlValue = value;
    }

    switch (toUnit) {
      case 'L':
        return mlValue / 1000;
      case 'US oz':
        return mlValue / 29.5735;
      default: 
        return mlValue;
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
