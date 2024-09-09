import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/water/water_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/water/water_state.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/buildAnimatedText.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/timepacker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/water_ToggleButtons.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';

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

final List<String> _units = ['mL', 'L', 'US oz'];

class _WaterPageState extends State<WaterPage> {
  @override
  void initState() {
    super.initState();
    context.read<WaterCubit>().fetchWeight();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                if (state.waterNeeded > 0)
                  Text(
                    'You will need to drink around: ${state.waterNeeded.toStringAsFixed(1)} ${state.selectedUnit} per day',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(
                  height: 10,
                ),
                const Timepacker(),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
