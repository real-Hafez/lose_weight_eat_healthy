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
      print('Error checking username: $e');
      return false;
    }
  }

  Future<void> saveUserDetails({
    required String email,
    required String firstName,
    required String lastName,
    required String userId,
    required String username,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
      });
      print('User details saved successfully.');
    } catch (e) {
      print('Error saving user details: $e');
    }
  }
}
