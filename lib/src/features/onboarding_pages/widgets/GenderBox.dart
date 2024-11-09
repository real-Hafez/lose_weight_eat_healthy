import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/cubit/GenderSelection/gender_selection_cubit.dart';

class GenderBox extends StatelessWidget {
  final String gender;
  final IconData? icon;
  final Widget? countryFlag; // Optional widget for country flag
  final VoidCallback? onTap; // Add the onTap parameter
  final bool? isSelected; // Nullable isSelected parameter

  const GenderBox({
    super.key,
    required this.gender,
    this.icon,
    this.countryFlag,
    this.onTap, // Accept onTap parameter
    this.isSelected, // Accept isSelected parameter
  });

  @override
  Widget build(BuildContext context) {
    // Determine if the GenderBox should be marked as selected
    final bool isSelectedValue = isSelected ?? false;

    return GestureDetector(
      onTap: onTap ??
          () {
            // Default behavior: Update the selected gender in the GenderSelectionCubit
            context.read<GenderSelectionCubit>().selectGender(gender);
          },
      child: BlocBuilder<GenderSelectionCubit, String?>(
        builder: (context, selectedGender) {
          // Determine selection state based on cubit state or the provided isSelected value
          final bool isSelectedCubit = selectedGender == gender;
          final bool isSelectedFinal = isSelectedValue || isSelectedCubit;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelectedFinal ? Colors.blue : Colors.grey,
                width: 5,
              ),
              color: isSelectedFinal ? Colors.blue[50] : Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    size: 80,
                    color: isSelectedFinal ? Colors.blue : Colors.grey,
                  )
                else if (countryFlag != null)
                  countryFlag!, // Display country flag if provided and icon is null
                const SizedBox(height: 10),
                Text(
                  gender,
                  style: TextStyle(
                    fontSize: 22,
                    color: isSelectedFinal ? Colors.blue : Colors.grey,
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
