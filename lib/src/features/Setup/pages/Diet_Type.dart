import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              const TitleWidget(
                title: 'What\'s Your Diet',
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              Column(
                children: [
                  Diet_Type_card(
                    text: 'Anything',
                    exclude: 'Nothing',
                    icon: FontAwesomeIcons.utensils,
                    color: Colors.green,
                    isSelected: _selectedDiet == 'Anything',
                    ontap: () => _selectDiet('Anything'),
                  ),
                  Diet_Type_card(
                    text: 'Keto',
                    exclude: 'Grains, Sugars, Starchy Vegetables',
                    icon: FontAwesomeIcons.bacon,
                    color: Colors.orange,
                    isSelected: _selectedDiet == 'Keto',
                    ontap: () => _selectDiet('Keto'),
                  ),
                  Diet_Type_card(
                    text: 'Vegetarian',
                    exclude: 'Meat, Poultry, Fish',
                    icon: FontAwesomeIcons.leaf,
                    color: Colors.lightGreen,
                    isSelected: _selectedDiet == 'Vegetarian',
                    ontap: () => _selectDiet('Vegetarian'),
                  ),
                  Diet_Type_card(
                    text: 'Vegan',
                    exclude: 'Animal Products (Meat, Dairy, Eggs, Honey)',
                    icon: FontAwesomeIcons.seedling,
                    color: Colors.greenAccent,
                    isSelected: _selectedDiet == 'Vegan',
                    ontap: () => _selectDiet('Vegan'),
                  ),
                  Diet_Type_card(
                    text: 'Paleo',
                    exclude: 'Grains, Legumes, Dairy, Processed Foods',
                    icon: FontAwesomeIcons.drumstickBite,
                    color: Colors.brown,
                    isSelected: _selectedDiet == 'Paleo',
                    ontap: () => _selectDiet('Paleo'),
                  ),
                  Diet_Type_card(
                    text: 'Mediterranean',
                    exclude: 'Refined Sugar, Processed Meat',
                    icon: FontAwesomeIcons.fish,
                    color: Colors.blueAccent,
                    isSelected: _selectedDiet == 'Mediterranean',
                    ontap: () => _selectDiet('Mediterranean'),
                  ),
                  Diet_Type_card(
                    text: 'Pescatarian',
                    exclude: 'Meat (except Fish)',
                    icon: FontAwesomeIcons.fish,
                    color: Colors.teal,
                    isSelected: _selectedDiet == 'Pescatarian',
                    ontap: () => _selectDiet('Pescatarian'),
                  ),
                  Diet_Type_card(
                    text: 'Gluten-Free',
                    exclude: 'Gluten (Wheat, Barley, Rye)',
                    icon: FontAwesomeIcons.breadSlice,
                    color: Colors.purple,
                    isSelected: _selectedDiet == 'Gluten-Free',
                    ontap: () => _selectDiet('Gluten-Free'),
                  ),
                ],
              ),
            ],
          ),
          // Inside the build method
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Visibility(
                visible: _selectedDiet !=
                    null, // Show button only when a diet is selected
                child: NextButton(
                  onPressed: () {
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
    required this.isSelected, // Add selection state
  });
  final String text;
  final String exclude;
  final IconData icon;
  final Color color;
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
                  color: color,
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
