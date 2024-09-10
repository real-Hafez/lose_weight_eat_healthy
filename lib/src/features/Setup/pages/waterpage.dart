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
  static const platform = MethodChannel('com.example.fuckin/widget');
  final List<String> _units = ['mL', 'L', 'US oz'];

  @override
  void initState() {
    super.initState();
    context.read<WaterCubit>().fetchWeight();
  }

  Future<void> _addWidgetToHomeScreen() async {
    try {
      final bool result = await platform.invokeMethod('addWidgetToHomeScreen');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result
              ? 'Widget added to home screen!'
              : 'Failed to add widget to home screen.'),
        ),
      );
    } on PlatformException catch (e) {
      print("Failed to add widget to home screen: '${e.message}'.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while adding the widget.')),
      );
    }
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
                      Text(
                        'You will need to drink around: ${state.waterNeeded.toStringAsFixed(1)} ${state.selectedUnit} per day',
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                const SizedBox(height: 24),

                if (state.selectedUnit != null && state.waterNeeded > 0)
                  const Timepacker(),

                const SizedBox(height: 24),

                if (state.wakeUpTimeSelected && state.sleepTimeSelected)
                  NextButton(
                      onPressed: widget.onNextButtonPressed,
                      collectionName: ''),

                // const SizedBox(height: 24),

                // // Step 6: Add the widget to home screen
                // if (state.wakeUpTimeSelected && state.sleepTimeSelected)
                //   Column(
                //     children: [
                //       AnimatedTextWidget(
                //         onFinished: () {
                //           context.read<WaterCubit>().finishAnimation();
                //           widget.onAnimationFinished();
                //         },
                //         text:
                //             'That\'s why you need a reminder to drink water',
                //       ),
                //       const SizedBox(height: 24),
                //       ElevatedButton(
                //         onPressed: _addWidgetToHomeScreen,
                //         child: const Text('Add to Home Screen'),
                //       ),
                // ],
                // ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
