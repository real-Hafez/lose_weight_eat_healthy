import 'package:auto_animated/auto_animated.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
      } else if (_selectedDishes.length < 32) {
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
              child: LiveGrid.options(
                options: const LiveOptions(
                  showItemDuration: Duration(milliseconds: 250),
                  showItemInterval: Duration(milliseconds: 80),
                  visibleFraction: 0.1,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _dishesToShow.length,
                itemBuilder: (context, index, animation) {
                  final dish = _dishesToShow[index];
                  return FadeTransition(
                    opacity: animation,
                    child: FavFoodCard(
                      isSelected: _selectedDishes.contains(dish),
                      ontap: () => _selectDish(dish),
                      text: dish,
                    ),
                  );
                },
              ),
            ),
            if (_selectedDishes.length < 3)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Please select at least 3 dishes',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
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
            child: _selectedDishes.length >= 3
                ? NextButton(
                    onPressed: () async {
                      await _saveSelectedDishes();
                      widget.onNextButtonPressed();
                    },
                    collectionName: "Dish",
                    dataToSave: {
                      'selectedDishes': _selectedDishes,
                    },
                    saveData: true,
                    userId: FirebaseAuth.instance.currentUser?.uid,
                  )
                : const SizedBox.shrink(),
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
