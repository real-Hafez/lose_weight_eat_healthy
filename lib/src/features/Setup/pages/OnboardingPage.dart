import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/FirstOnboardinggPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/SecondOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/ThirdOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/fourthOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/ffifthOnboardingPage.dart';
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
    if (currentPage < 4) {
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
              FirstOnboardingPage(onAnimationFinished: _onAnimationFinished),
              Secondonboardingpage(
                onAnimationFinished: _onAnimationFinished,
                onNextButtonPressed: _handleNextButtonPress,
              ),
              thirdOnboardingPage(
                onAnimationFinished: _onAnimationFinished,
                onNextButtonPressed: _handleNextButtonPress,
                onHeightUnitChanged: _onHeightUnitChanged,
              ),
              fourthOnboardingPage(
                onAnimationFinished: _onAnimationFinished,
                onNextButtonPressed: _handleNextButtonPress,
                heightUnit: _heightUnit,
              ),
              ffifthOnboardingPage(
                  onAnimationFinished: _onAnimationFinished,
                  onNextButtonPressed: _handleNextButtonPress),
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
      default:
        return '';
    }
  }
}
