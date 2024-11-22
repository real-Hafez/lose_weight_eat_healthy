import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/3_onboarding_gender_selecthion/cubit/GenderSelection/gender_selection_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/cubit/on-boarding/onboarding_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/cubit/on-boarding/onboarding_state.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/4_onboarding_main_use_for_app/page/maintarget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/BodyFatPercentagePage.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/5_onboarding_DietSelection/page/DietSelection_Screen.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/Finishpage.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/1_onboarding_language_selecthion/screen/languagescreen.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/3_onboarding_gender_selecthion/screen/GenderSelectionPage.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/6_onboarding_Height_selecthion/page/HeightSelectionPage.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/HowQuick_Youwant_to_lose_weight.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/page/WeightSetup_Page.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/2_onboarding_welocme_msg/screen/WelcomeOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/page/weight_ShortTerm_Goal.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/WaterPage_setup.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/water_widget.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

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
                    LanguageSelectionPage(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
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
                    Maintarget(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    DietSelection_Screen(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    // FavFood(
                    //   onAnimationFinished: () {
                    //     context.read<OnboardingCubit>().showNextButton();
                    //   },
                    //   onNextButtonPressed: () {
                    //     context.read<OnboardingCubit>().nextPage();
                    //   },
                    // ),
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
                    WeightSetup_Page(
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
                    weight_ShortTerm_Goal(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                    ),
                    // HowQuickYouWantToLoseWeight(
                    //   onAnimationFinished: () {
                    //     context.read<OnboardingCubit>().showNextButton();
                    //   },
                    //   onNextButtonPressed: () {
                    //     context.read<OnboardingCubit>().nextPage();
                    //   },
                    // ),
                    // BodyFatPercentagePage(
                    //   onAnimationFinished: () {
                    //     context.read<OnboardingCubit>().showNextButton();
                    //   },
                    //   onNextButtonPressed: () {
                    //     context.read<OnboardingCubit>().nextPage();
                    //   },
                    // ),
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
