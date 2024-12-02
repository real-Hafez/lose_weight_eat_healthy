import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NutritionCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<NutritionCubit, NutritionState>(
          builder: (context, state) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: cubit.nutritionData.keys.map((diet) {
                  return GestureDetector(
                    onTap: () => cubit.selectDiet(diet),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: state.selectedDiet == diet
                            ? Colors.teal.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: state.selectedDiet == diet
                              ? Colors.teal
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        diet,
                        style: TextStyle(
                          color: state.selectedDiet == diet
                              ? Colors.teal
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        BlocBuilder<NutritionCubit, NutritionState>(
          builder: (context, state) {
            return state.selectedDiet == "Create Your Own"
                ? _buildCustomDietControls(context)
                : _buildNutritionDetails(
                    cubit.currentNutritionData,
                  );
          },
        ),
      ],
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
                  icon: Icons.local_fire_department_rounded,
                  color: Colors.blue,
                ),
                const Divider(height: 20, color: Colors.grey),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCustomDietControls(BuildContext context) {
    final cubit = context.read<NutritionCubit>();
    final totalCalories = cubit.calculateCalories();

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
              "Total Calories: $totalCalories kcal",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: totalCalories > 2000 ? Colors.red : Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              label: "Protein",
              value: cubit.state.customProtein,
              color: Colors.blue,
              onChanged: (value) => cubit.updateCustomProtein(value),
            ),
            _buildSlider(
              label: "Carbs",
              value: cubit.state.customCarbs,
              color: Colors.green,
              onChanged: (value) => cubit.updateCustomCarbs(value),
            ),
            _buildSlider(
              label: "Fat",
              value: cubit.state.customFat,
              color: Colors.orange,
              onChanged: (value) => cubit.updateCustomFat(value),
            ),
          ],
        ),
      ),
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
