import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/buildAnimatedText.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'dart:async';

class Finishpage extends StatefulWidget {
  const Finishpage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  _FinishpageState createState() => _FinishpageState();
}

class _FinishpageState extends State<Finishpage> {
  final List<String> steps = [
    'Making your workout Routines...',
    'Making your Nutrition ...',
    'Set Up Your water reminders ',
  ];

  int currentStep = 0;
  bool isCurrentStepCompleted = false;
  bool areAllStepsCompleted = false;
  bool showButton = false;

  @override
  void initState() {
    super.initState();
    _startStepAnimation();
  }

  void _startStepAnimation() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentStep < steps.length) {
        setState(() {
          if (isCurrentStepCompleted) {
            currentStep++;
            isCurrentStepCompleted = false;
          } else {
            isCurrentStepCompleted = true;
          }
        });
      } else {
        timer.cancel();
        setState(() {
          areAllStepsCompleted = true;
        });
        widget.onAnimationFinished();

        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            showButton = true;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentStep < steps.length)
            FinishWidget(
              text: steps[currentStep],
              isCompleted: isCurrentStepCompleted,
            ),
          if (areAllStepsCompleted) ...[
            AnimatedTextWidget(
              onFinished: () {},
              text: 'Just 30 days to reach your goal try to active our dream ',
            ),
            const SizedBox(height: 20),
            if (showButton)
              ElevatedButton(
                onPressed: widget.onNextButtonPressed,
                child: const Text('Start activating your dream'),
              ),
          ],
        ],
      ),
    );
  }
}

class FinishWidget extends StatelessWidget {
  const FinishWidget({
    super.key,
    required this.text,
    required this.isCompleted,
  });

  final String text;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          SizedBox(
            height: 35,
            width: 35,
            child: isCompleted
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const AppLoadingIndicator(),
          ),
        ],
      ),
    );
  }
}
