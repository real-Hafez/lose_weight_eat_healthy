import 'package:flutter/material.dart';

class CustomTextStyle extends StatelessWidget {
  final String main_text;
  final String sub_text;

  const CustomTextStyle({
    required this.main_text,
    super.key,
    required this.sub_text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            main_text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            sub_text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
