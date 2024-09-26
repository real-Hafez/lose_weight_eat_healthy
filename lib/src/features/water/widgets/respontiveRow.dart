import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_event.dart';

class WaterIntakeCard extends StatelessWidget {
  final IconData icon;
  final double amount;
  final Color backgroundColor;

  const WaterIntakeCard({
    super.key,
    required this.icon,
    required this.amount,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<WaterBloc>().add(AddWaterIntake(amount));
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
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
              Text(
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

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children
          .map((child) => Expanded(
                child: Padding(
                  padding: isSmallScreen
                      ? const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        )
                      : const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                  child: child,
                ),
              ))
          .toList(),
    );
  }
}
