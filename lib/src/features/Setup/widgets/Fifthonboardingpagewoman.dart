import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

class Fifthonboardingpagewoman extends StatefulWidget {
  const Fifthonboardingpagewoman({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  State<Fifthonboardingpagewoman> createState() =>
      _FifthonboardingpagewomanState();
}

class _FifthonboardingpagewomanState extends State<Fifthonboardingpagewoman> {
  final List<String> imagePaths = [
    'assets/body_percentage_fat/body_percentage_fat_woman/body_percentage_fat_13.jpg',
    'assets/body_percentage_fat/body_percentage_fat_woman/body_percentage_fat_16.jpg',
    'assets/body_percentage_fat/body_percentage_fat_woman/body_percentage_fat_19.jpg',
    'assets/body_percentage_fat/body_percentage_fat_woman/body_percentage_fat_22.jpg',
    'assets/body_percentage_fat/body_percentage_fat_woman/body_percentage_fat_25.jpg',
    'assets/body_percentage_fat/body_percentage_fat_woman/body_percentage_fat_28.jpg',
    'assets/body_percentage_fat/body_percentage_fat_woman/body_percentage_fat_33.jpg',
    'assets/body_percentage_fat/body_percentage_fat_woman/body_percentage_fat_38.jpg',
    'assets/body_percentage_fat/body_percentage_fat_woman/body_percentage_fat_44.jpg',
  ];

  double currentValue = 25;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _updatePercentageBasedOnScroll();
    });
  }

  void _updatePercentageBasedOnScroll() {
    double offset = _scrollController.offset;
    double maxScroll = _scrollController.position.maxScrollExtent;
    double minPercentage = 13;
    double maxPercentage = 45;

    double imageWidth = 200;
    double imageSpacing = 16;
    double totalScrollableWidth =
        (imageWidth + imageSpacing) * (imagePaths.length - 1);

    if (maxScroll > 0) {
      double positionFactor = offset / maxScroll;
      double interpolatedValue =
          minPercentage + positionFactor * (maxPercentage - minPercentage);

      setState(() {
        currentValue = interpolatedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProgressIndicatorWidget(
          value: 0.6,
        ),
        const SizedBox(height: 20),
        TitleWidget(title: S().bodyfatwoman),
        const SizedBox(height: 10),
        Column(
          children: [
            Text(
              "${currentValue.toStringAsFixed(0)}%",
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      size: MediaQuery.of(context).size.height * .1,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: imagePaths.map((path) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.asset(
                    path,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(
          height: 300,
        ),
        NextButton(
          saveData: true,
          onPressed: widget.onNextButtonPressed,
          collectionName: 'body percentage fat',
          dataToSave: {
            'bodyFatPercentage': currentValue.toStringAsFixed(0),
          },
          userId: FirebaseAuth.instance.currentUser?.uid,
        ),
        const SizedBox(
          height: 10,
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
