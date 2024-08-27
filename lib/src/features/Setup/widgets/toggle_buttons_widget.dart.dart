import 'package:flutter/material.dart';

class ToggleButtonsWidget extends StatelessWidget {
  final String heightUnit;
  final void Function(String unit) onUnitChanged;

  const ToggleButtonsWidget({
    Key? key,
    required this.heightUnit,
    required this.onUnitChanged,
  }) : super(key: key);

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
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('cm'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('ft'),
          ),
        ],
      ),
    );
  }
}
