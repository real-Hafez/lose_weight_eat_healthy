import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/buildAnimatedText.dart';

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

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showAuthor = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedTextWidget(
            onFinished: widget.onAnimationFinished,
            text: '"Water is the driving force of all nature."',
          ),
          const SizedBox(height: 8),
          AnimatedOpacity(
            opacity: _showAuthor ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Text(
              '- Leonardo da Vinci',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.blueGrey[600],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
