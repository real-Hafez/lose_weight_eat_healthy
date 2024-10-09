import 'package:flutter/material.dart';

class UsernameErrorText extends StatelessWidget {
  final bool isUsernameTaken;

  const UsernameErrorText({Key? key, required this.isUsernameTaken})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isUsernameTaken) {
      return const Padding(
        padding: EdgeInsets.only(top: 5, left: 5),
        child: Text(
          'Username is already taken',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
