import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_event.dart';

class hydration_card_widget extends StatelessWidget {
  final IconData icon;
  final double amount;
  final Color backgroundColor;
  final bool isEditMode;

  const hydration_card_widget({
    super.key,
    required this.icon,
    required this.amount,
    required this.backgroundColor,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController controller =
        TextEditingController(text: amount.toStringAsFixed(1));

    return GestureDetector(
      onTap: () {
        if (!isEditMode) {
          context.read<WaterBloc>().add(AddWaterIntake(amount));
        }
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: backgroundColor,
        child: SizedBox(
          height: 120,
          width: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
              const SizedBox(
                height: 10,
              ),
              isEditMode
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: controller,
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
                          // Update the amount based on user input
                          double newAmount = double.tryParse(value) ?? 0.0;
                          context
                              .read<WaterBloc>()
                              .add(AddWaterIntake(newAmount));
                        },
                      ),
                    )
                  : Text(
                      amount.toStringAsFixed(1),
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
}
