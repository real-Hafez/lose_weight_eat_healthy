import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';

class WaterTogglebuttons extends StatelessWidget {
  final List<String> units;
  final String? selectedUnit;
  final Function(int) onUnitSelected;

  const WaterTogglebuttons({
    super.key,
    required this.units,
    required this.selectedUnit,
    required this.onUnitSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            S().unit,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ToggleButtons(
            isSelected: units.map((unit) => unit == selectedUnit).toList(),
            onPressed: onUnitSelected,
            children: units
                .map((unit) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(unit),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
