import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/second_onboarding_welocme_msg/widget/buildAnimatedText.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';

class WelcomeOnboardingPage extends StatefulWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  const WelcomeOnboardingPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  @override
  State<WelcomeOnboardingPage> createState() => _WelcomeOnboardingPageState();
}

class _WelcomeOnboardingPageState extends State<WelcomeOnboardingPage> {
  bool _showNextButton = false;
  bool _skipAnimation = false;
  Key _animatedTextKey = UniqueKey();

  @override
  void initState() {
    super.initState();
  }

  void _onSkipPressed() {
    setState(() {
      _skipAnimation = true;
      _animatedTextKey = UniqueKey();
      _showNextButton = true;
    });
    widget.onAnimationFinished();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            ProgressIndicatorWidget(value: 0.1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: AnimatedTextWidget(
                key: _animatedTextKey,
                onFinished: () {
                  setState(() {
                    _showNextButton = true;
                  });
                  widget.onAnimationFinished();
                },
                text: S.of(context).welcomeonboarding,
                instantDisplay: _skipAnimation,
              ),
            ),
            const Spacer(),
            _showNextButton
                ? NextButton(
                    onPressed: widget.onNextButtonPressed,
                    saveData: false,
                  )
                : const SizedBox.shrink(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .01,
            ),
          ],
        ),

        // Only show the skip button if the animation is still running and when finish show the next in next button to go to nex t on boadring screen
        if (!_showNextButton)
          Positioned(
            bottom: 20,
            right: 20,
            child: TextButton(
              onPressed: _onSkipPressed,
              child: Text(
                S.of(context).skipButton,
                style: TextStyle(
                    fontSize: MediaQuery.sizeOf(context).height * .03,
                    color: Colors.blue),
              ),
            ),
          ),
      ],
    );
  }
}
