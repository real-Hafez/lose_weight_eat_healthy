import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/GenderSelectionPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/WelcomeOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/HeightSelectionPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/WeightSelectionPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/BodyFatPercentagePage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/sixthOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  bool _showNextButton = false;
  String _heightUnit = 'cm'; // Default value

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onAnimationFinished() {
    setState(() {
      _showNextButton = true;
    });
  }

  void _handleNextButtonPress() {
    final currentPage = _pageController.page?.toInt() ?? 0;

    if (currentPage < 5) {
      // If we're not yet on the last page, move to the next page
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _showNextButton = false;
      });
    }
  }

  void _onHeightUnitChanged(String heightUnit) {
    setState(() {
      _heightUnit = heightUnit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              WelcomeOnboardingPage(onAnimationFinished: _onAnimationFinished),
              GenderSelectionPage(
                onAnimationFinished: _onAnimationFinished,
                onNextButtonPressed: _handleNextButtonPress,
              ),
              HeightSelectionPage(
                onAnimationFinished: _onAnimationFinished,
                onNextButtonPressed: _handleNextButtonPress,
                onHeightUnitChanged: _onHeightUnitChanged,
              ),
              WeightSelectionPage(
                onAnimationFinished: _onAnimationFinished,
                onNextButtonPressed: _handleNextButtonPress,
                heightUnit: _heightUnit,
              ),
              BodyFatPercentagePage(
                onAnimationFinished: _onAnimationFinished,
                onNextButtonPressed: _handleNextButtonPress,
              ),
              SixthOnboardingPage(
                onAnimationFinished: _onAnimationFinished,
                onNextButtonPressed: _handleNextButtonPress,
              ),
            ],
          ),
          if (_showNextButton)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: NextButton(
                  onPressed: _handleNextButtonPress,
                  collectionName:
                      _getCollectionName(), // Provide collection name
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getCollectionName() {
    final currentPage = _pageController.page?.toInt() ?? 0;
    switch (currentPage) {
      case 1:
        return 'gender';
      case 2:
        return 'height';
      case 3:
        return 'weight';
      case 4:
        return 'body fat percentage';
      default:
        return '';
    }
  }
}
