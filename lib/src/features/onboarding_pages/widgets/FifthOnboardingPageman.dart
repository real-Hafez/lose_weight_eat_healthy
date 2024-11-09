import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';

class Fifthonboardingpageman extends StatefulWidget {
  const Fifthonboardingpageman({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  State<Fifthonboardingpageman> createState() => _FifthonboardingpagemanState();
}

class _FifthonboardingpagemanState extends State<Fifthonboardingpageman> {
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

  double currentValue = 22;
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
    double minPercentage = 9;
    double maxPercentage = 42;

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
        TitleWidget(title: S().bodyfatman),
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
                    // height: MediaQuery.of(context).size.height * .39,
                    // width: MediaQuery.of(context).size.width * .5,
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
