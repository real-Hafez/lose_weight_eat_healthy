import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class create_account_Text extends StatelessWidget {
  const create_account_Text({
    super.key, required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AutoSizeText(
      text,
        maxLines: 1,
        maxFontSize: 40,
        minFontSize: 22,
        style: TextStyle(
            color: Colors.grey,
            fontSize: MediaQuery.of(context).size.height * .04),
      ),
    );
  }
}
