import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_state.dart';
import 'package:lose_weight_eat_healthy/src/shared/toast_shared.dart';

class EditWaterGoalDialog extends StatelessWidget {
  final double currentWaterGoal;
  static const double maxWaterGoalML = 8000.0;
  static const double maxWaterGoalL = 8.0;
  static const double maxWaterGoalUSoz = 271.0;

  const EditWaterGoalDialog({
    super.key,
    required this.currentWaterGoal,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: currentWaterGoal.toString());

    return AlertDialog(
      title: Text("${S().watergoal}"),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "${S().waternewgoal}",
        ),
        onChanged: (value) {
          double? enteredValue = double.tryParse(value);
          if (enteredValue != null) {
            String currentUnit = _getCurrentUnit(context);
            if (!_validateWaterGoal(enteredValue, currentUnit)) {
              ToastUtil.showToast(
                  "${S().waterendgoal} $maxWaterGoalML ${S().mL} / $maxWaterGoalL ${S().Litres} / $maxWaterGoalUSoz ${S().USoz}");
            }
          }
        },
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        TextButton(
          child: const Text("Save"),
          onPressed: () {
            double? newWaterGoal = double.tryParse(controller.text);
            if (newWaterGoal != null && newWaterGoal > 0) {
              String currentUnit = _getCurrentUnit(context);
              if (_validateWaterGoal(newWaterGoal, currentUnit)) {
                Navigator.of(context).pop(newWaterGoal);
              } else {
                ToastUtil.showToast(
                    "Water goal cannot exceed the limit of $maxWaterGoalML mL / $maxWaterGoalL L / $maxWaterGoalUSoz US oz");
              }
            } else {
              ToastUtil.showToast("Invalid water goal entered");
            }
          },
        ),
      ],
    );
  }

//make sure that uiser not put more that 8 L
  bool _validateWaterGoal(double waterGoal, String unit) {
    if (unit == 'mL') {
      return waterGoal <= maxWaterGoalML;
    } else if (unit == 'L') {
      return waterGoal <= maxWaterGoalL;
    } else if (unit == 'US oz') {
      return waterGoal <= maxWaterGoalUSoz;
    }
    return false;
  }

  String _getCurrentUnit(BuildContext context) {
    final state = context.read<WaterBloc>().state;
    if (state is WaterLoaded) {
      return state.unit;
    } else {
      return 'mL';
    }
  }
}
