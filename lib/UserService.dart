import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isUsernameTaken(String username) async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      return result.docs.isNotEmpty;
    } catch (e) {
      // Handle error if needed
      return false;
    }
  }
}
