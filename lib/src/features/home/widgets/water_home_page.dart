import 'package:flutter/material.dart';

class water_home_page extends StatelessWidget {
  const water_home_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .2,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}
