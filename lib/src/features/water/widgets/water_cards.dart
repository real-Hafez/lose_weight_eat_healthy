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
    if (cardAmounts.isEmpty) {
      return const Text("No water intake recorded.");
    }

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
                amount: cardAmounts.isNotEmpty ? cardAmounts[0] : 0,
                cardIndex: 0,
              ),
              hydration_card_widget(
                isEditMode: isEditMode,
                icon: Icons.local_drink,
                backgroundColor: Colors.lightBlue,
                amount: cardAmounts.length > 1 ? cardAmounts[1] : 0,
                cardIndex: 1,
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
                amount: cardAmounts.length > 2 ? cardAmounts[2] : 0,
                cardIndex: 2,
              ),
              hydration_card_widget(
                isEditMode: isEditMode,
                icon: Icons.local_bar,
                backgroundColor: Colors.purpleAccent,
                amount: cardAmounts.length > 3 ? cardAmounts[3] : 0,
                cardIndex: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
