import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/water/water_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/water/water_state.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/buildAnimatedText.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/timepacker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/water_ToggleButtons.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterPage extends StatefulWidget {
  const WaterPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  _WaterPageState createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  final List<String> _units = ['mL', 'L', 'US oz'];

  @override
  void initState() {
    super.initState();
    context.read<WaterCubit>().fetchWeight();
  }

  Future<void> _saveWaterIntakeToPrefs(double waterNeeded, String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('water_needed', waterNeeded);
    await prefs.setString('water_unit', unit);
    print(waterNeeded);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WaterCubit, WaterState>(
        builder: (context, state) {
          if (state is WaterInitial || state is WaterLoading) {
            return const AppLoadingIndicator();
          } else if (state is WaterError) {
            return Center(child: Text(state.message));
          } else if (state is WaterLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedTextWidget(
                  onFinished: () {
                    context.read<WaterCubit>().finishAnimation();
                    widget.onAnimationFinished();
                  },
                  text: 'What water measurement do you use?',
                ),
                const SizedBox(height: 24),
                if (state.animationFinished)
                  WaterTogglebuttons(
                    units: _units,
                    selectedUnit: state.selectedUnit,
                    onUnitSelected: (int index) {
                      final selectedUnit = _units[index];
                      context
                          .read<WaterCubit>()
                          .updateSelectedUnit(selectedUnit);
                    },
                  ),
                const SizedBox(height: 24),
                if (state.selectedUnit != null && state.waterNeeded > 0)
                  Column(
                    children: [
                      AutoSizeText(
                        'You will need to drink around: ${state.waterNeeded.toStringAsFixed(1)} ${state.selectedUnit} per day',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                        maxLines: 1,
                        maxFontSize: 24,
                        minFontSize: 14,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                if (state.selectedUnit != null && state.waterNeeded > 0)
                  const Timepacker(),
                const SizedBox(height: 24),
                if (state.wakeUpTimeSelected)
                  NextButton(
                      onPressed: () async {
                        widget.onNextButtonPressed();
                        await _saveWaterIntakeToPrefs(
                          state.waterNeeded,
                          state.selectedUnit!,
                        );
                      },
                      collectionName: ''),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
