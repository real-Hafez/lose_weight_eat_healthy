import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
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
    print("Firestore offline persistence enabled.");
  }

  Future<void> fetchAndCalculateCalorieNeeds(String userId, int age) async {
    emit(CalorieCubitLoading());
    print("Fetching calorie needs for user ID: $userId and age: $age");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? gender = prefs.getString('gender_$userId');
      double weightKg = prefs.getDouble('weight_$userId') ?? 0.0;
      double heightCm = prefs.getDouble('height_$userId') ?? 0.0;
      double dailyCalories = prefs.getDouble('calories_$userId') ?? 0.0;

      print("Data loaded from SharedPreferences:");
      print("Gender: $gender");
      print("Weight (kg): $weightKg");
      print("Height (cm): $heightCm");
      print("Daily Calories: $dailyCalories");

      if (gender != null &&
          weightKg != 0.0 &&
          heightCm != 0.0 &&
          dailyCalories != 0.0) {
        print("Complete data loaded from SharedPreferences.");
      }

      if (gender == null ||
          weightKg == 0.0 ||
          heightCm == 0.0 ||
          dailyCalories == 0.0) {
        print(
            "Incomplete data in SharedPreferences, fetching from Firestore...");

        gender = await _getUserGender(userId);
        print("Fetched Gender from Firestore: $gender");

        weightKg = await _getUserWeight(userId);
        print("Fetched Weight from Firestore: $weightKg");

        heightCm = await _getUserHeight(userId);
        print("Fetched Height from Firestore: $heightCm");

        if (weightKg == 0.0 || heightCm == 0.0) {
          emit(const CalorieCubitError(
              "Please provide your height and weight."));
          print("Error: Please provide your height and weight.");
          return;
        }

        double bmr = _calculateBMR(gender, weightKg, heightCm, age);
        print("Calculated BMR: $bmr");

        dailyCalories = _calculateDailyCalories(bmr);
        print("Calculated Daily Calories: $dailyCalories");

        await prefs.setString('gender_$userId', gender);
        await prefs.setDouble('weight_$userId', weightKg);
        await prefs.setDouble('height_$userId', heightCm);
        await prefs.setDouble('calories_$userId', dailyCalories);

        print("Data fetched from Firestore and saved to SharedPreferences");
      }

      // Fetch the user's weight loss goal from Firestore
      String goal = await _getUserWeightLossGoal(userId);
      print("Fetched Goal from Firestore: $goal");

      double adjustedCalories = dailyCalories;

      // Adjust daily calories based on the goal
      if (goal == "Lose 1 kg per week") {
        adjustedCalories -= 1000;
      } else if (goal == "Lose 0.5 kg per week") {
        adjustedCalories -= 500;
      }

      // Save the adjusted calorie amount
      await prefs.setDouble('adjusted_calories_$userId', adjustedCalories);

      emit(CalorieCubitSuccess(adjustedCalories));
      print("Emission success with adjusted calories: $adjustedCalories");

      // Save the adjusted calories in SharedPreferences
      await prefs.setDouble('adjusted_calories_$userId', adjustedCalories);
      print("Adjusted calories saved to SharedPreferences: $adjustedCalories");
    } catch (e) {
      emit(CalorieCubitError(e.toString()));
      print("Error occurred: ${e.toString()}");
    }
  }

  // Helper to calculate BMR
  double _calculateBMR(
      String gender, double weightKg, double heightCm, int age) {
    if (gender == "Male" || gender == "ذكر") {
      return 10 * weightKg + 6.25 * heightCm - 5 * age + 5;
    } else {
      return 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
    }
  }

  Future<String> _getUserWeightLossGoal(String userId) async {
    try {
      DocumentSnapshot goalDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('HowMuchLosing_weight_per_week')
          .doc('data')
          .get();

      if (goalDoc.exists) {
        final goalData = goalDoc.data() as Map<String, dynamic>?;

        if (goalData != null && goalData.containsKey('Goal')) {
          return goalData['Goal'];
        }
      }
      throw Exception("Missing weight loss goal data.");
    } catch (e) {
      print("Error fetching weight loss goal: ${e.toString()}");
      throw Exception("Error fetching weight loss goal: ${e.toString()}");
    }
  }

  // Helper to calculate daily calorie needs
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
      print("Error fetching gender: ${e.toString()}");
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
      print("Weight document does not exist.");
      return 0.0;
    } catch (e) {
      print("Error fetching weight: ${e.toString()}");
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
      print("Height document does not exist.");
      return 0.0;
    } catch (e) {
      print("Error fetching height: ${e.toString()}");
      throw Exception("Error fetching height: ${e.toString()}");
    }
  }
}
