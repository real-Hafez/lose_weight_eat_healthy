import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_event.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class hydration_card_widget extends StatefulWidget {
  final IconData icon;
  final double amount;
  final Color backgroundColor;
  final bool isEditMode;
  final int cardIndex;

  const hydration_card_widget({
    super.key,
    required this.icon,
    required this.amount,
    required this.backgroundColor,
    required this.isEditMode,
    required this.cardIndex,
  });

  @override
  _HydrationCardWidgetState createState() => _HydrationCardWidgetState();
}

class _HydrationCardWidgetState extends State<hydration_card_widget> {
  late TextEditingController _controller;
  late double _currentAmount;

  @override
  void initState() {
    super.initState();
    _loadSavedAmount();
    _controller = TextEditingController(text: widget.amount.toStringAsFixed(1));
    _currentAmount = widget.amount;
  }

  Future<void> _loadSavedAmount() async {
    final prefs = await SharedPreferences.getInstance();
    double? savedAmountInMl = prefs.getDouble('card_${widget.cardIndex}');

    if (savedAmountInMl != null) {
      String currentUnit = _getCurrentUnit();
      double convertedAmount =
          convertWaterAmount(savedAmountInMl, 'mL', currentUnit);
      setState(() {
        _currentAmount = convertedAmount;
        _controller.text = convertedAmount.toStringAsFixed(1);
      });
    }
  }

  double convertWaterAmount(double amount, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) {
      return amount;
    }

    if (fromUnit == 'mL') {
      if (toUnit == 'L') {
        return amount / 1000;
      } else if (toUnit == 'US oz') {
        return amount * 0.033814;
      }
    } else if (fromUnit == 'L') {
      if (toUnit == 'mL') {
        return amount * 1000;
      } else if (toUnit == 'US oz') {
        return amount * 33.814;
      }
    } else if (fromUnit == 'US oz') {
      if (toUnit == 'mL') {
        return amount / 0.033814;
      } else if (toUnit == 'L') {
        return amount / 33.814;
      }
    }

    return amount;
  }

  String _getCurrentUnit() {
    final state = context.read<WaterBloc>().state;

    if (state is WaterLoaded) {
      return state.unit;
    } else {
      return 'mL';
    }
  }

  Future<void> _saveAmount(double newAmount) async {
    final prefs = await SharedPreferences.getInstance();
    String currentUnit = _getCurrentUnit();
    double amountInMl = convertWaterAmount(newAmount, currentUnit, 'mL');
    await prefs.setDouble('card_${widget.cardIndex}', amountInMl);
    setState(() {
      _currentAmount = newAmount;
    });
  }

  Future<void> _saveOnExit() async {
    double? newAmount = double.tryParse(_controller.text);
    if (newAmount != null) {
      await _saveAmount(newAmount);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEditMode) {
      _saveOnExit();
    }

    return GestureDetector(
      onTap: () {
        if (!widget.isEditMode) {
          context.read<WaterBloc>().add(AddWaterIntake(_currentAmount));
        }
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: widget.backgroundColor,
        child: SizedBox(
          height: 120,
          width: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 30,
                color: Colors.white,
              ),
              const SizedBox(
                height: 10,
              ),
              widget.isEditMode
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                          controller: _controller,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.black,
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          onSubmitted: (value) {
                            double? newAmount = double.tryParse(value);
                            if (newAmount != null) {
                              String currentUnit = _getCurrentUnit();
                              double convertedAmount = convertWaterAmount(
                                  newAmount, currentUnit, _getCurrentUnit());
                              _saveAmount(convertedAmount);
                            }
                          }),
                    )
                  : Text(
                      _currentAmount.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
