import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // List of units to choose from
  final List<String> _units = ['L', 'ml', 'US oz'];
  int _selectedIndex = 0; // Index for the selected unit

  @override
  void initState() {
    super.initState();
    _loadSelectedUnit();
  }

  // Load the selected unit from SharedPreferences
  Future<void> _loadSelectedUnit() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUnit = prefs.getString('water_unit') ?? 'ml';
    setState(() {
      _selectedIndex = _units.indexOf(savedUnit);
    });
  }

  // Save the selected unit to SharedPreferences
  Future<void> _saveSelectedUnit(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedUnit = _units[index];
    await prefs.setString('water_unit', selectedUnit);
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
                  _units.length, (index) => index == _selectedIndex),
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
