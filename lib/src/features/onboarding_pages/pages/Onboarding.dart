import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
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
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/page/WeightSetup_Page.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/2_onboarding_welocme_msg/screen/WelcomeOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/page/weight_ShortTerm_Goal.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/9_onboarding_Waterpage/page/WaterPage_setup.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/9_onboarding_Waterpage/widget/water_widget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';
import 'package:numberpicker/numberpicker.dart';

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
                    HowOldAreYou(
                      onAnimationFinished: () {
                        context.read<OnboardingCubit>().showNextButton();
                      },
                      onNextButtonPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
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
                    WeightGoalPage(
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

class HowOldAreYou extends StatefulWidget {
  const HowOldAreYou({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  State<HowOldAreYou> createState() => _HowOldAreYouState();
}

class _HowOldAreYouState extends State<HowOldAreYou> {
  int selectedAge = 20; // Initial value for age selection

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Progress indicator at the top
          ProgressIndicatorWidget(value: 0.3),

          // Title at the top
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: TitleWidget(title: S().howold),
          ),

          // Spacer to push the NumberPicker to the center
          const Spacer(),

          NumberPicker(
            value: selectedAge,
            minValue: 3,
            maxValue: 100,
            onChanged: (value) {
              setState(() {
                selectedAge = value;
              });
            },
            textStyle: TextStyle(
                fontSize: MediaQuery.sizeOf(context).height * .02,
                color: Colors.grey),
            selectedTextStyle: TextStyle(
              fontSize: MediaQuery.sizeOf(context).height * .04,
              fontWeight: FontWeight.bold,
            ),
            textMapper: (numberText) {
              // Convert numbers to Arabic if the locale is Arabic
              return isArabic
                  ? NumberConversionHelper.convertToArabicNumbers(numberText)
                  : numberText;
            },
          ),

          // Spacer to balance the layout
          const Spacer(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
