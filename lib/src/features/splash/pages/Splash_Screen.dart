import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/setup.dart';
import 'package:lose_weight_eat_healthy/src/features/Navigator_Bar/page/BottomNavBar_main.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding/screen/onboarding.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
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
      return const OnBoarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getNextScreen(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return FlutterSplashScreen.gif(
            gifPath: 'assets/giphy_logo_google_GIF.webp',
            gifWidth: 200,
            gifHeight: 474,
            duration: const Duration(milliseconds: 6000),
            nextScreen: const SizedBox.shrink(),
            onInit: () {
              if (mounted) {}
            },
          );
        }

        if (snapshot.hasData && mounted) {
          return snapshot.data!;
        } else {
          print('Error or no data, defaulting to OnBoarding.');
          return const OnBoarding();
        }
      },
    );
  }
}
