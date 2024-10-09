import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';

class ToggleButtonsWidget extends StatelessWidget {
  final String heightUnit;
  final void Function(String unit) onUnitChanged;

  const ToggleButtonsWidget({
    super.key,
    required this.heightUnit,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleButtons(
        isSelected: [heightUnit == 'cm', heightUnit == 'ft'],
        onPressed: (int index) {
          onUnitChanged(index == 0 ? 'cm' : 'ft');
        },
        borderColor: Colors.grey,
        selectedBorderColor: Colors.green,
        selectedColor: Colors.white,
        fillColor: Colors.green,
        borderRadius: BorderRadius.circular(8),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(S().cm),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(S().ft),
          ),
        ],
      ),
    );
  }
}
