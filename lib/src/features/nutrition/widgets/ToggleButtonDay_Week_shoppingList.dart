import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Day_page/Pages/Day_page.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Week_page/pages/Week_Page.dart';

class ToggleButtonDay_Week_shoppingList extends StatefulWidget {
  const ToggleButtonDay_Week_shoppingList({super.key});

  @override
  _ToggleButtonDay_Week_shoppingListState createState() =>
      _ToggleButtonDay_Week_shoppingListState();
}

class _ToggleButtonDay_Week_shoppingListState
    extends State<ToggleButtonDay_Week_shoppingList> {
  int selectedIndex = 0; // Default is set to Day (index 0)

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final activeTextStyle = TextStyle(
          fontSize: MediaQuery.of(context).size.height * .03,
          color: Colors.white,
        );
        final inactiveTextStyle = TextStyle(
          fontSize: MediaQuery.of(context).size.height * .03,
          color: Colors.black54,
        );

        return Container(
          width: double.infinity,
          padding: EdgeInsets.zero,
          child: Center(
            child: Container(
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildToggleButton(
                    'Day',
                    index: 0,
                    isSelected: selectedIndex == 0,
                    textStyle: selectedIndex == 0
                        ? activeTextStyle
                        : inactiveTextStyle,
                    constraints: constraints,
                  ),
                  _buildToggleButton(
                    'Week',
                    index: 1,
                    isSelected: selectedIndex == 1,
                    textStyle: selectedIndex == 1
                        ? activeTextStyle
                        : inactiveTextStyle,
                    constraints: constraints,
                  ),
                  _buildToggleButton(
                    'Shopping List',
                    index: 2,
                    isSelected: selectedIndex == 2,
                    textStyle: selectedIndex == 2
                        ? activeTextStyle.copyWith(
                            fontSize: MediaQuery.of(context).size.height * .02,
                          )
                        : inactiveTextStyle.copyWith(
                            fontSize: MediaQuery.of(context).size.height * .02,
                          ),
                    constraints: constraints,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleButton(
    String label, {
    required int index,
    required bool isSelected,
    required TextStyle textStyle,
    required BoxConstraints constraints,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        // Navigate to the appropriate page based on the selected index
        if (selectedIndex == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DayPage()),
          );
        } else if (selectedIndex == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WeekPage()),
          );
        } else if (selectedIndex == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DayPage()), //  ShoppingListPage is here maKE SURE TO ADD IT
          );
        }
      },
      child: SizedBox(
        width: constraints.maxWidth / 3,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.deepPurpleAccent.withOpacity(0.8)
                : Colors.grey[300],
            border: isSelected
                ? const Border(
                    bottom: BorderSide(color: Colors.red, width: 3),
                  )
                : null,
          ),
          child: Center(
            child: AutoSizeText(
              label,
              style: textStyle,
              maxLines: 1,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
