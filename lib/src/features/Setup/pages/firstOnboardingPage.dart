import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/FirstOnboardinggPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/secondOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/buildAnimatedText.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  bool _showNextButton = false; // Track if button should be visible

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onAnimationFinished() {
    setState(() {
      _showNextButton = true; // Show the button when animation finishes
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
              SecondOnboardingPage(onAnimationFinished: _onAnimationFinished),
            ],
          ),
          if (_showNextButton) // Show button only when `_showNextButton` is true
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: NextButton(
                  onPressed: () {
                    if (_pageController.page == 0) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                      setState(() {
                        _showNextButton = false; // Reset for the next page
                      });
                    }
                    // Handle other pages or actions if needed
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
