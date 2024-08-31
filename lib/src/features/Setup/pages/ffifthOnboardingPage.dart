import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/TitleWidget.dart';

class FifthOnboardingPage extends StatefulWidget {
  const FifthOnboardingPage(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  State<FifthOnboardingPage> createState() => _FifthOnboardingPageState();
}

class _FifthOnboardingPageState extends State<FifthOnboardingPage> {
  final List<String> imagePaths = [
    'assets/body_percentage_fat/body_percentage_fat_man/body_percentage_fat_8%.jpg',
    'assets/body_percentage_fat/body_percentage_fat_man/body_percentage_fat_10%.jpg',
    'assets/body_percentage_fat/body_percentage_fat_man/body_percentage_fat_15%.jpg',
    'assets/body_percentage_fat/body_percentage_fat_man/body_percentage_fat_20%.jpg',
    'assets/body_percentage_fat/body_percentage_fat_man/body_percentage_fat_25%.jpg',
    'assets/body_percentage_fat/body_percentage_fat_man/body_percentage_fat_30%.jpg',
    'assets/body_percentage_fat/body_percentage_fat_man/body_percentage_fat_35%.jpg',
    'assets/body_percentage_fat/body_percentage_fat_man/body_percentage_fat_40%.jpg',
  ];

  double currentValue = 22; // Default to 22% body fat
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _updatePercentageBasedOnScroll();
    });
  }

  // Update percentage dynamically based on the scroll position
  void _updatePercentageBasedOnScroll() {
    double offset = _scrollController.offset;
    double maxScroll = _scrollController.position.maxScrollExtent;

    double positionFactor = offset / maxScroll; // Normalize to [0, 1] range
    double minPercentage = 8;
    double maxPercentage = 40;

    // Map the position to the corresponding body fat percentage
    double interpolatedValue =
        minPercentage + positionFactor * (maxPercentage - minPercentage);

    setState(() {
      currentValue = interpolatedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress Indicator (can be customized to reflect the user's journey)
        ProgressIndicatorWidget(
          value: 0.6,
        ),
        const SizedBox(height: 20),

        // Title section
        const TitleWidget(title: 'Choose your body fat percentage'),
        const SizedBox(height: 10),

        // Stack for percentage number and pointer
        Column(
          // alignment: Alignment.center,
          children: [
            // Display the current percentage dynamically
            Text(
              "${currentValue.toStringAsFixed(0)}%", // Display as a whole number
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 28, // Slightly larger font size for better visibility
                fontWeight: FontWeight.bold,
              ),
            ),
            // Vertical line and arrow to connect percentage to image
            const SizedBox(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      size: 40,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Horizontal scrollable image row
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: imagePaths.map((Path) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.asset(
                    Path,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(
          height: 300,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
