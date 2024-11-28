import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';
import 'package:numberpicker/numberpicker.dart';

class HowOldAreYou extends StatefulWidget {
  const HowOldAreYou({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  State<HowOldAreYou> createState() => _HowOldAreYouState();
}

class _HowOldAreYouState extends State<HowOldAreYou> {
  int selectedAge = 20; // Initial value for age selection

  // Function to save the age in shared preferences
  Future<void> _saveAge() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('age', selectedAge);
    print("Age saved: $selectedAge"); // Debug log
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Progress indicator at the top
          ProgressIndicatorWidget(value: 0.3),

          // Title at the top
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: TitleWidget(title: S().howold),
          ),

          // Spacer to push the NumberPicker to the center
          const Spacer(),

          NumberPicker(
            value: selectedAge,
            minValue: 3,
            maxValue: 100,
            onChanged: (value) {
              setState(() {
                selectedAge = value;
              });
            },
            textStyle: TextStyle(
                fontSize: MediaQuery.sizeOf(context).height * .02,
                color: Colors.grey),
            selectedTextStyle: TextStyle(
              fontSize: MediaQuery.sizeOf(context).height * .04,
              fontWeight: FontWeight.bold,
            ),
            textMapper: (numberText) {
              // Convert numbers to Arabic if the locale is Arabic
              return isArabic
                  ? NumberConversionHelper.convertToArabicNumbers(numberText)
                  : numberText;
            },
          ),

          // Spacer to balance the layout to maintain a  design
          const Spacer(),
          NextButton(
            onPressed: () async {
              await _saveAge(); // Save the selected agee
              widget.onNextButtonPressed();
            },
            collectionName: 'age',
            saveData: true,
            dataToSave: {
              'user_age': selectedAge, // Pass the selected age
            },
            userId: FirebaseAuth.instance.currentUser?.uid,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
