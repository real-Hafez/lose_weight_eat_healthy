import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/cubit/cubit/weight_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/cubit/cubit/weight_state.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/widget/Bmi_card.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/widget/KgPicker.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/widget/LbPicker.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/widget/ToggleButtonsWidgetkg.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';

class WeightSelectionView extends StatelessWidget {
  final VoidCallback onNextButtonPressed;

  const WeightSelectionView({required this.onNextButtonPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightCubit, WeightState>(
      builder: (context, state) {
        final cubit = context.read<WeightCubit>();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProgressIndicatorWidget(value: 0.4),
                SizedBox(height: MediaQuery.sizeOf(context).height * .02),
                TitleWidget(title: S().weight),
                SizedBox(height: MediaQuery.sizeOf(context).height * .02),
                ToggleButtonsWidgetkg(
                  weightUnit: state.weightUnit,
                  onUnitChanged: (unit) => cubit.updateWeightUnit(unit),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * .06),
                Container(
                  width: double.infinity,
                  child: Center(
                    child: state.weightUnit == 'kg'
                        ? KgPicker(
                            weightKg: state.weightKg,
                            onWeightChanged: cubit.updateWeight,
                          )
                        : LbPicker(
                            weightLb: state.weightLb,
                            onWeightChanged: cubit.updateWeight,
                          ),
                  ),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * .03),
                Bmi_Card(bmiValue: state.bmi),
                SizedBox(height: MediaQuery.sizeOf(context).height * .02),
                NextButton(
                  collectionName: 'weight',
                  onPressed: () async {
                    await cubit.savePreferences();
                    onNextButtonPressed();
                  },
                  dataToSave: {
                    'weightKg': state.weightKg,
                    'weightLb': state.weightLb,
                    'weightUnit': state.weightUnit,
                  },
                  userId: FirebaseAuth.instance.currentUser?.uid,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
