import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/GenderSelection/gender_selection_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/on-boarding/onboarding_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/on-boarding/onboarding_state.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/BodyFatPercentagePage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/GenderSelectionPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/HeightSelectionPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/WeightSelectionPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/WelcomeOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/WeightLossMessageWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/waterpage.dart';

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
                    BodyFatPercentagePage(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    WaterPage(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    )
                  ],
                ),
                // BlocBuilder<OnboardingCubit, OnboardingState>(
                //   builder: (context, state) {
                //     return Positioned(
                //       bottom: 20,
                //       left: 20,
                //       right: 20,
                // child: Align(
                //   alignment: Alignment.bottomCenter,
                //   child: state.showNextButton
                //       ? NextButton(
                //           onPressed: () =>
                //               context.read<OnboardingCubit>().nextPage(),
                //           collectionName: context
                //               .read<OnboardingCubit>()
                //               .getCollectionName(),
                //         )
                //       : const SizedBox.shrink(),
                // ),
                //     );
                //   },
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
