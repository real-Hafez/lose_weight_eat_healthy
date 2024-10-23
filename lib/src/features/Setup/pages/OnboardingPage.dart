import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/GenderSelection/gender_selection_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/on-boarding/onboarding_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/on-boarding/onboarding_state.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/BodyFatPercentagePage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/Diet_Type.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/Fav_food.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/Finishpage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/GenderSelectionPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/HeightSelectionPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/HowQuick_Youwant_to_lose_weight.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/WeightSelectionPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/WelcomeOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/WeightLossMessageWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/WaterPage_setup.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/water_widget.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        body: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            return Stack(
              children: [
                PageView(
                  controller: context.read<OnboardingCubit>().pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    WelcomeOnboardingPage(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    BlocProvider(
                      create: (_) => GenderSelectionCubit(),
                      child: GenderSelectionPage(
                        onAnimationFinished: () {
                          context.read<OnboardingCubit>().showNextButton();
                        },
                        onNextButtonPressed: () {
                          context.read<OnboardingCubit>().nextPage();
                        },
                      ),
                    ),
                    DietType(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    FavFood(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    HeightSelectionPage(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onHeightUnitChanged: (unit) {
                        context.read<OnboardingCubit>().changeHeightUnit(unit);
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    WeightSelectionPage(
                      heightUnit: state.heightUnit,
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    WeightLossMessageWidget(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    HowQuickYouWantToLoseWeight(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    BodyFatPercentagePage(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    WaterPage_setup(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    WaterWidget(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    Finishpage(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
