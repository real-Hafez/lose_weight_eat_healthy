import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/2_onboarding_welocme_msg/widget/buildAnimatedText.dart';

class WaterWidget extends StatefulWidget {
  const WaterWidget({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  State<WaterWidget> createState() => _WaterWidgetState();
}

class _WaterWidgetState extends State<WaterWidget> {
  bool _showAuthor = false;
  bool _showSecondQuote = false;
  bool _showImage = false;
  bool _showAddWidgetButton = false;
  bool _showNextButton = false;
  bool _showSkip = true; // Initially, skip button is visible
  bool _skipAnimation = false; // New flag to control instant display

  static const platform =
      MethodChannel('com.example.lose_weight_eat_healthy/widget');

  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    _startDelays();
  }

  void _startDelays() {
    _timers.add(Timer(const Duration(seconds: 4), () {
      if (mounted && !_skipAnimation) {
        setState(() => _showAuthor = true);
      }
    }));

    _timers.add(Timer(const Duration(seconds: 5), () {
      if (mounted && !_skipAnimation) {
        setState(() => _showSecondQuote = true);
      }
    }));

    _timers.add(Timer(const Duration(seconds: 14), () {
      if (mounted && !_skipAnimation) {
        setState(() => _showImage = true);
      }
    }));

    _timers.add(Timer(const Duration(seconds: 15), () {
      if (mounted && !_skipAnimation) {
        setState(() {
          _showAddWidgetButton = true;
        });
      }
    }));
  }

  Future<void> _addWidgetToHomeScreen() async {
    try {
      final bool result = await platform.invokeMethod('addWidgetToHomeScreen');
      print(result);

      if (mounted) {
        setState(() {
          _showNextButton = true;
          _showSkip = false; // Hide skip button when completed
        });
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _showAllContent() {
    for (var timer in _timers) {
      timer.cancel();
    }
    setState(() {
      _skipAnimation = true; // Instantly display all content
      _showAuthor = true;
      _showSecondQuote = true;
      _showImage = true;
      _showAddWidgetButton = true;
      _showNextButton = true;
      _showSkip = false; // Hide skip button
    });
  }

  @override
  void dispose() {
    for (var timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProgressIndicatorWidget(value: 0.8),
              AnimatedTextWidget(
                onFinished: widget.onAnimationFinished,
                text: S().quote,
                instantDisplay: _skipAnimation,
              ),
              const SizedBox(height: 8),
              AnimatedOpacity(
                opacity: _showAuthor ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  S().quotesaider,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.blueGrey[600],
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 16),
              if (_showSecondQuote)
                AnimatedTextWidget(
                  onFinished: widget.onAnimationFinished,
                  text: S().waterwidget,
                  instantDisplay: _skipAnimation,
                ),
              const SizedBox(height: 16),
              if (_showImage)
                InkWell(
                  onTap: _addWidgetToHomeScreen,
                  child: Image.asset(
                    'assets/on-boarding-assets/widget_preview.png',
                  ),
                ),
              const SizedBox(height: 24),
              if (_showAddWidgetButton)
                ElevatedButton(
                  onPressed: _addWidgetToHomeScreen,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(S().addwidget),
                ),
              const SizedBox(height: 10),
              if (_showNextButton)
                NextButton(
                  onPressed: () {
                    _showAllContent();
                    widget.onNextButtonPressed();
                  },
                  collectionName: '',
                ),
            ],
          ),
          if (_showSkip)
            Positioned(
              bottom: 20,
              right: 20,
              child: TextButton(
                onPressed: _showAllContent,
                child: Text(
                  S().skipButton,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
