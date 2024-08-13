import 'package:flutter/cupertino.dart';

class onboarding_Second_page extends StatelessWidget {
  const onboarding_Second_page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 40),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // SizedBox(height: 10000), // Adjust space here as needed
          Text(
            'Description Text 2',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
