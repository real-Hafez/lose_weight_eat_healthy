import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';

class ToggleButtonsWidgetkg extends StatelessWidget {
  final String weightUnit;
  final void Function(String unit) onUnitChanged;

  const ToggleButtonsWidgetkg({
    super.key,
    required this.weightUnit,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleButtons(
        isSelected: [weightUnit == 'kg', weightUnit == 'lb'],
        onPressed: (int index) {
          onUnitChanged(index == 0 ? 'kg' : 'lb');
        },
        borderColor: Colors.grey,
        selectedBorderColor: Colors.green,
        selectedColor: Colors.white,
        fillColor: Colors.green,
        borderRadius: BorderRadius.circular(8),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(S().kg),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(S().lb),
          ),
        ],
      ),
    );
  }
}
