import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/GenderSelection/gender_selection_cubit.dart';

class GenderBox extends StatelessWidget {
  final String gender;
  final IconData icon;

  const GenderBox({
    Key? key,
    required this.gender,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<GenderSelectionCubit>().selectGender(gender);
      },
      child: BlocBuilder<GenderSelectionCubit, String?>(
        builder: (context, selectedGender) {
          final bool isSelected = selectedGender == gender;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey,
                width: 2,
              ),
              color: isSelected ? Colors.blue[50] : Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 80, color: isSelected ? Colors.blue : Colors.grey),
                const SizedBox(height: 10),
                Text(
                  gender,
                  style: TextStyle(
                    fontSize: 22,
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
