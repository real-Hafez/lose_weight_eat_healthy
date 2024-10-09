import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/Routes/app_routes.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ProgressIndicatorWidget.dart';
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
    S().setp1,
    S().step2,
    S().step2,
  ];

  int currentStep = 0;
  bool isCurrentStepCompleted = false;
  bool areAllStepsCompleted = false;
  bool showButton = false;
  Timer? _timer; // Declare a Timer variable

  @override
  void initState() {
    super.initState();
    _startStepAnimation();
  }

  void _startStepAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return; // Check if the widget is still mounted
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
        timer.cancel(); // Cancel the timer when all steps are completed
        setState(() {
          areAllStepsCompleted = true;
        });
        widget.onAnimationFinished();

        Future.delayed(const Duration(seconds: 3), () {
          if (!mounted) return; 
          setState(() {
            showButton = true;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer in dispose
    super.dispose(); // Call the superclass dispose method
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProgressIndicatorWidget(value: 0.9),
          if (currentStep < steps.length)
            FinishWidget(
              text: steps[currentStep],
              isCompleted: isCurrentStepCompleted,
            ),
          if (areAllStepsCompleted) ...[
            AnimatedTextWidget(
              onFinished: () {},
              text: S().motivationalText,
            ),
            const SizedBox(height: 20),
            if (showButton)
              ElevatedButton(
                style: const ButtonStyle(enableFeedback: true),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.loginForAnother);
                },
                child: Text(S().buttonText),
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
