import 'package:flutter/material.dart';

class ToggleButtonsWidgetkg extends StatelessWidget {
  final String weightUnit;
  final void Function(String unit) onUnitChanged;

  const ToggleButtonsWidgetkg({
    Key? key,
    required this.weightUnit,
    required this.onUnitChanged,
  }) : super(key: key);

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
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('kg'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('lb'),
          ),
        ],
      ),
    );
  }
}
