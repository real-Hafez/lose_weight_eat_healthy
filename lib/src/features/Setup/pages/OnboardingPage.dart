import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/FirstOnboardinggPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/SecondOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/ThirdOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/fourthOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  bool _showNextButton = false;

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
    if (currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _showNextButton = false;
      });
    }
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
              SecondOnboardingPage(
                onAnimationFinished: _onAnimationFinished,
                onNextButtonPressed:
                    _handleNextButtonPress, // Pass the callback
              ),
              ThirdOnboardingPage(
                onAnimationFinished: _onAnimationFinished,
                onNextButtonPressed:
                    _handleNextButtonPress, // Pass the callback
              ),
              fourthOnboardingPage(
                onAnimationFinished: _onAnimationFinished,
                onNextButtonPressed:
                    _handleNextButtonPress, // Pass the callback
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
                ),
              ),
            ),
        ],
      ),
    );
  }
}
