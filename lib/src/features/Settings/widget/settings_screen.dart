import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Settings/widget/Water_unit_preferences.dart';

class settings_screen extends StatelessWidget {
  const settings_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Mahmood hafez',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.green,
              maxRadius: 60,
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * .03,
        ),
        Container(
            width: MediaQuery.sizeOf(context).width * .9,
            height: MediaQuery.sizeOf(context).height * .3,
            decoration: ShapeDecoration(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(33),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width * .015),
                    child: AutoSizeText(
                      'Account \nSettings',
                      maxLines: 2,
                      minFontSize: 18,
                      maxFontSize: 40,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Kirang_Haerang',
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.sizeOf(context).height * .040,
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
