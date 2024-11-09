import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/cubit/water/water_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/cubit/water/water_state.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/buildAnimatedText.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/timepacker.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/water_ToggleButtons.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterPage_setup extends StatefulWidget {
  const WaterPage_setup({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  _WaterPage_setupState createState() => _WaterPage_setupState();
}

class _WaterPage_setupState extends State<WaterPage_setup> {
  final List<String> _units = [(S().mL), (S().Litres), (S().USoz)];
  TimeOfDay? _wakeUpTime;
  TimeOfDay? _sleepTime;

  @override
  void initState() {
    super.initState();
    context.read<WaterCubit>().fetchWeight();
    _loadSavedPreferences();
  }

  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _wakeUpTime = _getTimeOfDayFromString(prefs.getString('wake_up_time'));
      _sleepTime = _getTimeOfDayFromString(prefs.getString('sleep_time'));
    });
  }

  Future<void> _savePreferences(double waterNeeded, String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('water_needed', waterNeeded);
    await prefs.setString('water_unit', unit);
    if (_wakeUpTime != null) {
      await prefs.setString('wake_up_time', _wakeUpTime!.format(context));
    }
    if (_sleepTime != null) {
      await prefs.setString('sleep_time', _sleepTime!.format(context));
    }

    print('Water Needed: $waterNeeded');
    print('Unit: $unit');
    print('Wake-up Time: ${_wakeUpTime?.format(context)}');
    print('Sleep Time: ${_sleepTime?.format(context)}');

    await _updateHomeScreenWidget(waterNeeded, unit);
  }

  Future<void> _updateHomeScreenWidget(double waterNeeded, String unit) async {
    const platform = MethodChannel('com.example.fuckin/widget');
    try {
      await platform.invokeMethod('updateWidget', {
        'water': waterNeeded,
        'unit': unit,
        'wake_up_time': _wakeUpTime?.format(context),
      });
    } catch (e) {
      print('Failed to update widget: $e');
    }
  }

  TimeOfDay? _getTimeOfDayFromString(String? time) {
    if (time != null) {
      const format = TimeOfDayFormat.h_colon_mm_space_a;
      return TimeOfDay.fromDateTime(DateFormat.jm().parse(time));
    }
    return null;
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
                ProgressIndicatorWidget(value: 0.7),
                AnimatedTextWidget(
                  onFinished: () {
                    context.read<WaterCubit>().finishAnimation();
                    widget.onAnimationFinished();
                  },
                  text: S().Water,
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
                        '${S().howmanywater} ${state.waterNeeded.toStringAsFixed(1)} ${state.selectedUnit} ${S().perday}',
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
                  Timepacker(
                    onWakeUpTimeSelected: (time) {
                      setState(() {
                        _wakeUpTime = time;
                      });
                      context.read<WaterCubit>().selectWakeUpTime(true);
                    },
                    onSleepTimeSelected: (time) {
                      setState(() {
                        _sleepTime = time;
                      });
                      context.read<WaterCubit>().selectSleepTime(true);
                    },
                  ),
                const SizedBox(height: 24),
                if (state.wakeUpTimeSelected)
                  NextButton(
                    onPressed: () async {
                      widget.onNextButtonPressed();
                      await _savePreferences(
                        state.waterNeeded,
                        state.selectedUnit!,
                      );
                    },
                    collectionName: '',
                  ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
