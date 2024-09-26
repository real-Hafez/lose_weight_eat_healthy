import 'package:flutter/material.dart';

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
