import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';

class DietOption_Card extends StatelessWidget {
  const DietOption_Card({
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
                        "${S().Exclude} : $exclude",
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
