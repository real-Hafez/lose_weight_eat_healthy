import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/calories_chart_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/nutrition_details_cubit_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/nutrition_details_cubit_state.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/widget/NutritionRow.dart';

class NutritionDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NutritionCubit(),
      child: _NutritionDetailsView(),
    );
  }
}

class _NutritionDetailsView extends StatelessWidget {
  // List of diet options
  final List<String> dietOptions = [
    "Balanced",
    "Low Fat",
    "Low Carb",
    "High Protein",
    "Create Your Own"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Diet Selection Tabs
        _buildDietTabs(context),
        const SizedBox(height: 16),

        // Nutrition Details or Custom Diet Controls
        BlocBuilder<NutritionCubit, NutritionState>(
          builder: (context, state) {
            return state.selectedDiet == "Create Your Own"
                ? _buildCustomDietControls(context)
                : _buildNutritionDetails(
                    context.read<NutritionCubit>().currentNutritionData);
          },
        ),
      ],
    );
  }

  Widget _buildDietTabs(BuildContext context) {
    final cubit = context.read<NutritionCubit>();

    return BlocBuilder<CaloriesChartCubit, CaloriesChartState>(
      builder: (context, state) {
        if (state is CaloriesChartLoaded) {
          // Update total calories if necessary
          if (cubit.state.totalCalories != state.finalCalories) {
            cubit.updateTotalCalories(state.finalCalories);
          }
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: dietOptions.map((diet) {
                final isSelected = cubit.state.selectedDiet == diet;

                return GestureDetector(
                  onTap: () {
                    // Only update if diet is different
                    if (!isSelected) {
                      cubit.updateDietAndRecalculate(diet);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.teal.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.teal : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      diet,
                      style: TextStyle(
                        color: isSelected ? Colors.teal : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNutritionDetails(Map<String, String> data) {
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

  Widget _buildCustomDietControls(BuildContext context) {
    return BlocBuilder<CaloriesChartCubit, CaloriesChartState>(
      builder: (context, state) {
        if (state is CaloriesChartLoaded) {
          final totalCalories = state.finalCalories;
          print('Loaded Total Calories: $totalCalories');

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Total Calories: ${totalCalories.toStringAsFixed(0)} kcal",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: totalCalories > 2000 ? Colors.red : Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSlider(
                    label: "Protein",
                    value: state.macros['Protein'] ?? 0,
                    color: Colors.blue,
                    onChanged: (value) => context
                        .read<NutritionCubit>()
                        .updateCustomProtein(value),
                  ),
                  _buildSlider(
                    label: "Carbs",
                    value: state.macros['Carbs'] ?? 0,
                    color: Colors.green,
                    onChanged: (value) =>
                        context.read<NutritionCubit>().updateCustomCarbs(value),
                  ),
                  _buildSlider(
                    label: "Fat",
                    value: state.macros['Fat'] ?? 0,
                    color: Colors.orange,
                    onChanged: (value) =>
                        context.read<NutritionCubit>().updateCustomFat(value),
                  ),
                ],
              ),
            ),
          );
        } else if (state is CaloriesChartLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Text("Failed to load data");
        }
      },
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ${value.toInt()} grams",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        Slider(
          value: value,
          min: 0,
          max: label == "Fat" ? 100 : 300,
          divisions: 100,
          activeColor: color,
          label: "${value.toInt()} g",
          onChanged: onChanged,
        ),
      ],
    );
  }
}
