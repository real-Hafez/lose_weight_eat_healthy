import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/setup.dart';
import 'package:lose_weight_eat_healthy/src/features/Navigator_Bar/page/BottomNavBar_main.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding/screen/IntroScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Widget> _getNextScreen() async {
    String? userUID = await _secureStorage.read(key: 'userUID');
    print('User UID: $userUID');

    if (userUID != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userUID);

      try {
        final collections = await Future.wait([
          userDoc.collection('body percentage fat').get(),
          userDoc.collection('gender').get(),
          userDoc.collection('height').get(),
          userDoc.collection('weight').get(),
          userDoc.collection('weight_loss').get(),
        ]);

        bool allCollectionsExist =
            collections.every((collection) => collection.docs.isNotEmpty);
        if (allCollectionsExist) {
          print('All required collections are present.');
          return const BottomNavBar_main();
        } else {
          print('Missing collections.');
          return const setup();
        }
      } catch (e) {
        print('Error checking collections: $e');
        return const setup();
      }
    } else {
      print('No userUID found in secure storage.');
      return const IntroScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Widget>(
        future: _getNextScreen(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/Google_logo.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Healthy Life', // Placeholder name for the app change later
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData) {
            if (mounted) {
              return snapshot.data!;
            } else {
              print('Widget unmounted before Future completed.');
              return const IntroScreen();
            }
          } else {
            print('Error or no data, defaulting to OnBoarding.');
            return const IntroScreen();
          }
        },
      ),
    );
  }
}
