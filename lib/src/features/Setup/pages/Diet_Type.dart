import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietType extends StatefulWidget {
  const DietType(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  _DietTypeState createState() => _DietTypeState();
}

class _DietTypeState extends State<DietType> {
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
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              const TitleWidget(
                title: 'What Type of Diet Do You Follow?',
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              Column(
                children: [
                  Diet_Type_card(
                    text: 'Anything',
                    exclude: 'Nothing',
                    icon: FontAwesomeIcons.utensils,
                    color: Colors.black,
                    iconcolor: Colors.green,
                    isSelected: _selectedDiet == 'Anything',
                    ontap: () => _selectDiet('Anything'),
                  ),
                  Diet_Type_card(
                    text: 'Vegetarian',
                    exclude: 'meat',
                    icon: FontAwesomeIcons.leaf,
                    color: Colors.black,
                    iconcolor: Colors.black,
                    isSelected: _selectedDiet == 'Vegetarian',
                    ontap: () => _selectDiet('Vegetarian'),
                  ),
                  Diet_Type_card(
                    text: 'Vegan',
                    exclude: 'all animal products',
                    icon: FontAwesomeIcons.carrot,
                    color: Colors.black,
                    iconcolor: Colors.brown,
                    isSelected: _selectedDiet == 'Vegan',
                    ontap: () => _selectDiet('Vegan'),
                  ),
                  Diet_Type_card(
                    text: 'keto',
                    exclude: 'Carbs, sugar, grains',
                    icon: FontAwesomeIcons.egg,
                    color: Colors.black,
                    iconcolor: Colors.white,
                    isSelected: _selectedDiet == 'keto',
                    ontap: () => _selectDiet('keto'),
                  )
                ],
              ),
            ],
          ),
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
          ),
        ],
      ),
    );
  }
}

class Diet_Type_card extends StatelessWidget {
  const Diet_Type_card({
    super.key,
    required this.text,
    required this.exclude,
    required this.icon,
    required this.color,
    required this.ontap,
    required this.isSelected,
    required this.iconcolor,
  });
  final String text;
  final String exclude;
  final IconData icon;
  final Color color;
  final Color iconcolor;

  final VoidCallback ontap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .03,
          vertical: MediaQuery.of(context).size.height * .008),
      child: InkWell(
        onTap: ontap,
        child: Card(
          color: Colors.grey.shade400,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isSelected
                  ? Colors.orange
                  : Colors.transparent, // Add border color based on selection
              width: 8.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .03,
                ),
                Icon(
                  icon,
                  size: 32,
                  color: iconcolor,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: color,
                          fontSize: 32,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Exclude: $exclude",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.clip,
                        maxLines: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
