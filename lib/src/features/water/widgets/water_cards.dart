import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/ResponsiveRow.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/hydration_card.dart';

class water_cards extends StatelessWidget {
  const water_cards({
    super.key,
    required this.cardAmounts,
    required this.isEditMode,
  });
  final bool isEditMode;

  final List<double> cardAmounts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResponsiveRow(
            children: [
              hydration_card_widget(
                isEditMode: isEditMode,
                icon: Icons.water_drop,
                backgroundColor: Colors.blueAccent,
                amount: cardAmounts[0],
              ),
              hydration_card_widget(
                isEditMode: isEditMode,
                icon: Icons.local_drink,
                backgroundColor: Colors.lightBlue,
                amount: cardAmounts[1],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ResponsiveRow(
            children: [
              hydration_card_widget(
                isEditMode: isEditMode,
                icon: Icons.local_cafe,
                backgroundColor: Colors.orangeAccent,
                amount: cardAmounts[2],
              ),
              hydration_card_widget(
                isEditMode: isEditMode,
                icon: Icons.local_bar,
                backgroundColor: Colors.purpleAccent,
                amount: cardAmounts[3],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
