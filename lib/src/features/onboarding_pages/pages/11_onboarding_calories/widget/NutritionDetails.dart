import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/calories_chart_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/nutrition_details_cubit_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/nutrition_details_cubit_state.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/widget/NutritionRow.dart';

class NutritionDetails extends StatelessWidget {
  final Function(String) onDietSelected;

  const NutritionDetails({super.key, required this.onDietSelected});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CaloriesChartCubit()..loadCaloriesData(),
      child: BlocBuilder<CaloriesChartCubit, CaloriesChartState>(
        builder: (context, state) {
          if (state is CaloriesChartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CaloriesChartLoaded) {
            final totalCalories = state.finalCalories;
            return BlocProvider(
              create: (_) => NutritionCubit(totalCalories),
              child: _NutritionDetailsView(onDietSelected: onDietSelected),
            );
          } else {
            return const Center(child: Text("Failed to load calorie data"));
          }
        },
      ),
    );
  }
}

class _NutritionDetailsView extends StatelessWidget {
  final Function(String) onDietSelected;

  final Map<String, String> dietOptions = {
    "Balanced": S().Balanced,
    "Low Fat": S().LowFat,
    "Low Carb": S().LowCarb,
    "High Protein": S().HighProtein,
  };

  _NutritionDetailsView({super.key, required this.onDietSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDietTabs(context),
        const SizedBox(height: 16),
        BlocBuilder<NutritionCubit, NutritionState>(
          builder: (context, state) {
            return _buildNutritionDetails(
              context, // Pass context here
              context.read<NutritionCubit>().currentNutritionData(
                  context), // Call currentNutritionData with context
            );
          },
        ),
      ],
    );
  }

  Widget _buildDietTabs(BuildContext context) {
    final cubit = context.read<NutritionCubit>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: dietOptions.entries.map((entry) {
            return GestureDetector(
              onTap: () {
                cubit.updateDietAndRecalculate(entry.key);
                onDietSelected(entry.key); // Use the key for internal logic
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: cubit.state.selectedDiet == entry.key
                      ? Colors.teal.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: cubit.state.selectedDiet == entry.key
                        ? Colors.teal
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  entry.value, // Display localized text
                  style: TextStyle(
                    color: cubit.state.selectedDiet == entry.key
                        ? Colors.teal
                        : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

Widget _buildNutritionDetails(BuildContext context, Map<String, String> data) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: data.entries.map((entry) {
          return Column(
            children: [
              NutritionRow(
                label: entry.key,
                value: entry.value,
                icon: _getIconForNutrient(entry.key),
                color: _getColorForNutrient(entry.key),
              ),
              if (entry.key != data.keys.last)
                const Divider(height: 20, color: Colors.grey),
            ],
          );
        }).toList(),
      ),
    ),
  );
}

IconData _getIconForNutrient(String nutrient) {
  switch (nutrient) {
    case 'Protein':
      return Icons.fitness_center;
    case 'Carbs':
      return Icons.rice_bowl;
    case 'Fat':
      return Icons.fastfood;
    default:
      return Icons.local_fire_department_rounded;
  }
}

Color _getColorForNutrient(String nutrient) {
  switch (nutrient) {
    case 'Protein':
      return Colors.blue;
    case 'Carbs':
      return Colors.green;
    case 'Fat':
      return Colors.orange;
    default:
      return Colors.teal;
  }
}

// Widget _buildCustomDietControls(BuildContext context) {
//   final cubit = context.read<NutritionCubit>();

//   return Card(
//     margin: const EdgeInsets.symmetric(horizontal: 16),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(12),
//     ),
//     elevation: 4,
//     child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Text(
//             "Adjust Your Macros:",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           // const SizedBox(height: 16),
//           // _buildMacroInput(
//           //   label: "Protein (grams)",
//           //   value: cubit.state.customProtein,
//           //   onChanged: (val) =>
//           //       cubit.updateCustomProtein(double.tryParse(val) ?? 0),
//           // ),
//           // const SizedBox(height: 8),
//           // _buildMacroInput(
//           //   label: "Carbs (grams)",
//           //   value: cubit.state.customCarbs,
//           //   onChanged: (val) =>
//           //       cubit.updateCustomCarbs(double.tryParse(val) ?? 0),
//           // ),
//           // const SizedBox(height: 8),
//           // _buildMacroInput(
//           //   label: "Fat (grams)",
//           //   value: cubit.state.customFat,
//           //   onChanged: (val) =>
//           //       cubit.updateCustomFat(double.tryParse(val) ?? 0),
//           // ),
//         ],
//       ),
//     ),
//   );
// }

Widget _buildMacroInput({
  required String label,
  required double value,
  required Function(String) onChanged,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
      SizedBox(
        width: 80,
        child: TextFormField(
          initialValue: value.toStringAsFixed(0),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
      ),
    ],
  );
}
