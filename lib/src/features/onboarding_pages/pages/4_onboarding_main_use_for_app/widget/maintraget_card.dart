import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class maintraget_card extends StatelessWidget {
  const maintraget_card({
    super.key,
    required this.card_text,
    required this.isSelected,
    required this.onTap,
  });

  final String card_text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .03,
        ),
        child: Card(
          color: isSelected ? const Color(0xFFC3FF4D) : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .1,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14.5),
            child: Center(
              child: AutoSizeText(
                card_text,
                maxFontSize: 30,
                minFontSize: 18,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height * .02,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
