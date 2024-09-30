import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

part 'calorie_state.dart';

class Calorie_Cubit extends Cubit<Calorie_State> {
  Calorie_Cubit() : super(CalorieCubitInitial()) {
    _enableFirestoreOffline();
  }

  // Enable Firestore offline persistence
  void _enableFirestoreOffline() {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true, // Enable offline persistence
    );
  }

  Future<void> fetchAndCalculateCalorieNeeds(String userId, int age) async {
    emit(CalorieCubitLoading());

    try {
      // Check for locally saved data in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? gender = prefs.getString('gender_$userId');
      double weightKg = prefs.getDouble('weight_$userId') ?? 0.0;
      double heightCm = prefs.getDouble('height_$userId') ?? 0.0;
      double dailyCalories = prefs.getDouble('calories_$userId') ?? 0.0;

      if (gender != null &&
          weightKg != 0.0 &&
          heightCm != 0.0 &&
          dailyCalories != 0.0) {
        print("Data loaded from SharedPreferences");
      }

      if (gender == null ||
          weightKg == 0.0 ||
          heightCm == 0.0 ||
          dailyCalories == 0.0) {
        print(
            "Incomplete data in SharedPreferences, fetching from Firestore...");

        gender = await _getUserGender(userId);
        weightKg = await _getUserWeight(userId);
        heightCm = await _getUserHeight(userId);

        if (weightKg == 0.0 || heightCm == 0.0) {
          emit(const CalorieCubitError(
              "Please provide your height and weight."));
          return;
        }

        double bmr = _calculateBMR(gender, weightKg, heightCm, age);

        dailyCalories = _calculateDailyCalories(bmr);

        await prefs.setString('gender_$userId', gender);
        await prefs.setDouble('weight_$userId', weightKg);
        await prefs.setDouble('height_$userId', heightCm);
        await prefs.setDouble('calories_$userId', dailyCalories);

        print("Data fetched from Firestore and saved to SharedPreferences");
      }

      emit(CalorieCubitSuccess(dailyCalories));
    } catch (e) {
      emit(CalorieCubitError(e.toString()));
    }
  }

  // Helper  calculate BMR
  double _calculateBMR(
      String gender, double weightKg, double heightCm, int age) {
    if (gender == "Male" || gender == "ذكر") {
      return 10 * weightKg + 6.25 * heightCm - 5 * age + 5;
    } else {
      return 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
    }
  }

  // Helper  calculate daily calorie neede 
  double _calculateDailyCalories(double bmr) {
    const double activityMultiplier = 1.55; // Moderately active
    return bmr * activityMultiplier;
  }

  // Fetch gender data from Firestore
  Future<String> _getUserGender(String userId) async {
    try {
      DocumentSnapshot genderDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('gender')
          .doc('data')
          .get();

      if (genderDoc.exists) {
        final genderData = genderDoc.data() as Map<String, dynamic>?;
        if (genderData != null && genderData.containsKey('selectedGender')) {
          return genderData['selectedGender'];
        }
      }
      throw Exception("Missing gender data.");
    } catch (e) {
      throw Exception("Error fetching gender: ${e.toString()}");
    }
  }

  Future<double> _getUserWeight(String userId) async {
    try {
      DocumentSnapshot weightDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('weight')
          .doc('data')
          .get();

      if (weightDoc.exists) {
        final weightData = weightDoc.data() as Map<String, dynamic>?;
        if (weightData != null && weightData.containsKey('weightKg')) {
          return (weightData['weightKg'] as num).toDouble();
        }
      }
      return 0.0;
    } catch (e) {
      throw Exception("Error fetching weight: ${e.toString()}");
    }
  }
  Future<double> _getUserHeight(String userId) async {
    try {
      DocumentSnapshot heightDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('height')
          .doc('data')
          .get();

      if (heightDoc.exists) {
        final heightData = heightDoc.data() as Map<String, dynamic>?;
        if (heightData != null && heightData.containsKey('heightCm')) {
          return (heightData['heightCm'] as num).toDouble();
        }
      }
      return 0.0;
    } catch (e) {
      throw Exception("Error fetching height: ${e.toString()}");
    }
  }
}
