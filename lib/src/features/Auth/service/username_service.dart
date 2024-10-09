import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkUsernameAvailability(String username) async {
  if (username.isEmpty) return false;

  try {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return result.docs.isNotEmpty;
  } catch (e) {
    return false;
  }
}
