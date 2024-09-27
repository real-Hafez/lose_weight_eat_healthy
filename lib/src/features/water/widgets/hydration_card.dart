import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class hydration_card_widget extends StatefulWidget {
  final IconData icon;
  final double amount;
  final Color backgroundColor;
  final bool isEditMode;
  final int cardIndex; // Card index for storing unique values.

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
    _loadSavedAmount(); // Load the saved amount for this card.
    _controller = TextEditingController(text: widget.amount.toStringAsFixed(1));
    _currentAmount = widget.amount;
  }

  // Load saved card amount from SharedPreferences
  Future<void> _loadSavedAmount() async {
    final prefs = await SharedPreferences.getInstance();
    double? savedAmount = prefs.getDouble('card_${widget.cardIndex}');
    if (savedAmount != null) {
      setState(() {
        _currentAmount = savedAmount;
        _controller.text = savedAmount.toStringAsFixed(1);
      });
    }
  }

  // Save card amount to SharedPreferences
  Future<void> _saveAmount(double newAmount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('card_${widget.cardIndex}', newAmount);
    setState(() {
      _currentAmount = newAmount;
    });
  }

  // Triggered when edit mode is turned off to save the latest value
  Future<void> _saveOnExit() async {
    double? newAmount = double.tryParse(_controller.text);
    if (newAmount != null) {
      await _saveAmount(newAmount);
    }
  }

  @override
  Widget build(BuildContext context) {
    // When edit mode is turned off, save the current amount
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
                            _saveAmount(
                                newAmount); // Save the new amount when user submits
                          }
                        },
                      ),
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
