import 'package:flutter/material.dart';

class EditWaterGoalDialog extends StatelessWidget {
  final double currentWaterGoal;

  const EditWaterGoalDialog({
    super.key,
    required this.currentWaterGoal,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: currentWaterGoal.toString());

    return AlertDialog(
      title: const Text("Edit Water Goal"),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Enter new water goal",
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(null); // Close the dialog without changes
          },
        ),
        TextButton(
          child: const Text("Save"),
          onPressed: () {
            double? newWaterGoal = double.tryParse(controller.text);
            if (newWaterGoal != null && newWaterGoal > 0) {
              Navigator.of(context)
                  .pop(newWaterGoal); // Return the new water goal
            } else {
              // Handle invalid input (e.g., show error message)
            }
          },
        ),
      ],
    );
  }
}
