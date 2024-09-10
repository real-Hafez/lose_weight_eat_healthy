import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _showSecondQuote = false;
  bool _showImage = false;
  bool _showbutton = false;

  static const platform = MethodChannel('com.example.fuckin/widget');

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

    // Delay for the second quote (5 seconds after the first animation)
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showSecondQuote = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 14), () {
      if (mounted) {
        setState(() {
          _showImage = true;
        });
      }
    });
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          _showbutton = true;
        });
      }
    });
  }

  Future<void> _addWidgetToHomeScreen() async {
    try {
      final bool result = await platform.invokeMethod('addWidgetToHomeScreen');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result
              ? 'Widget added to home screen!'
              : 'Failed to add widget to home screen.'),
        ),
      );
    } on PlatformException catch (e) {
      print("Failed to add widget to home screen: '${e.message}'.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while adding the widget.')),
      );
    }
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
          const SizedBox(height: 16),
          if (_showSecondQuote)
            AnimatedTextWidget(
              onFinished: widget.onAnimationFinished,
              text:
                  'The best way to achieve your dreams is to keep them in sight. That\'s why you need to add this widget to your home screen.',
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
          if (_showbutton)
            ElevatedButton(
              onPressed: _addWidgetToHomeScreen,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Add the widget'),
            ),
        ],
      ),
    );
  }
}
