import 'package:flutter/material.dart';

class WaterIntakeCard extends StatelessWidget {
  final IconData icon;
  final int amount;
  final Color backgroundColor;

  const WaterIntakeCard({
    super.key,
    required this.icon,
    required this.amount,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = MediaQuery.of(context).size.height * .04;
    final textSize = MediaQuery.of(context).size.height * .02;
    final padding = MediaQuery.of(context).size.width * .03;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: Colors.blue[900],
          ),
          SizedBox(
            width: padding,
          ),
          Text(
            '$amount ml',
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children
          .map((child) => Expanded(
                child: Padding(
                  padding: isSmallScreen
                      ? const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        )
                      : const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                  child: child,
                ),
              ))
          .toList(),
    );
  }
}
