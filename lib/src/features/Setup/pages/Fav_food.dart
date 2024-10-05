import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/dietDishes.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavFood extends StatefulWidget {
  const FavFood(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  State<FavFood> createState() => _FavFoodState();
}

class _FavFoodState extends State<FavFood> {
  final List<String> _selectedDishes = [];
  String? _savedDiet;
  List<String> _dishesToShow = [];

  Future<void> _getSavedDiet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedDiet = prefs.getString('selectedDiet');
      _dishesToShow = DietDishes.getDishesForDiet(_savedDiet);
    });
  }

  @override
  void initState() {
    super.initState();
    _getSavedDiet();
  }

  void _selectDish(String dish) {
    setState(() {
      if (_selectedDishes.contains(dish)) {
        _selectedDishes.remove(dish);
      } else if (_selectedDishes.length < 5) {
        _selectedDishes.add(dish);
      }
    });
  }

  Future<void> _saveSelectedDishes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedDishes', _selectedDishes);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const TitleWidget(
              title: 'What\'s Your Favourite Dishes?',
            ),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _dishesToShow.length,
                itemBuilder: (context, index) {
                  final dish = _dishesToShow[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: FavFoodCard(
                      isSelected: _selectedDishes.contains(dish),
                      ontap: () => _selectDish(dish),
                      text: dish,
                    ),
                  );
                },
              ),
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
                await _saveSelectedDishes();
                widget.onNextButtonPressed();
              },
              collectionName: "Dish",
              dataToSave: {
                'selectedGender': _selectedDishes,
              },
              saveData: true,
              userId: FirebaseAuth.instance.currentUser?.uid,
            ),
          ),
        ),
      ],
    );
  }
}

class FavFoodCard extends StatelessWidget {
  const FavFoodCard(
      {super.key,
      required this.text,
      required this.ontap,
      required this.isSelected});
  final String text;
  final VoidCallback ontap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Card(
        color: isSelected ? Colors.green : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: AutoSizeText(
              text,
              maxFontSize: 26,
              minFontSize: 14,
              maxLines: 3,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              wrapWords: false,
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.height * .055,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
