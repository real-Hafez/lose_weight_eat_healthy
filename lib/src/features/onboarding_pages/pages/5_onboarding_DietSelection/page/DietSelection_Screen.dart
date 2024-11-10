import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/5_onboarding_DietSelection/widget/DietOption_Card.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietSelection_Screen extends StatefulWidget {
  const DietSelection_Screen(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;
  @override
  _DietSelection_ScreenState createState() => _DietSelection_ScreenState();
}

class _DietSelection_ScreenState extends State<DietSelection_Screen> {
  String _selectedDiet = 'Anything';
  void _selectDiet(String diet) {
    setState(() {
      _selectedDiet = diet;
    });
    print('User chose: $diet');
  }

  Future<void> _saveSelectedDiet(String diet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedDiet', diet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            TitleWidget(title: S().diet),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Column(children: [
              DietOption_Card(
                text: S().Restrictions,
                exclude: S().nothing,
                icon: FontAwesomeIcons.utensils,
                color: Colors.black,
                iconcolor: Colors.green,
                isSelected: _selectedDiet == 'Anything',
                ontap: () => _selectDiet('Anything'),
              ),
              DietOption_Card(
                text: S().Vegetarian,
                exclude: S().meat,
                icon: FontAwesomeIcons.leaf,
                color: Colors.black,
                iconcolor: Colors.black,
                isSelected: _selectedDiet == 'Vegetarian',
                ontap: () => _selectDiet('Vegetarian'),
              ),
              DietOption_Card(
                  text: S().Vegan,
                  exclude: S().allanimalproducts,
                  icon: FontAwesomeIcons.carrot,
                  color: Colors.black,
                  iconcolor: Colors.brown,
                  isSelected: _selectedDiet == 'Vegan',
                  ontap: () => _selectDiet('Vegan')),
              DietOption_Card(
                  text: S().Keto,
                  exclude: S().Carbssugargrains,
                  icon: FontAwesomeIcons.egg,
                  color: Colors.black,
                  iconcolor: Colors.white,
                  isSelected: _selectedDiet == 'keto',
                  ontap: () => _selectDiet('keto'))
            ])
          ]),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: NextButton(
            onPressed: () async {
              await _saveSelectedDiet(_selectedDiet);

              widget.onNextButtonPressed();
            },
            collectionName: "Diet",
            dataToSave: {
              'selectedGender': _selectedDiet,
            },
            saveData: true,
            userId: FirebaseAuth.instance.currentUser?.uid,
          ),
        ),
      )
    ]));
  }
}
