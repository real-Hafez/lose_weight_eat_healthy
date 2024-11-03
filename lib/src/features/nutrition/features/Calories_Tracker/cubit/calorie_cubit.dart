import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'calorie_state.dart';

class Calorie_Cubit extends Cubit<Calorie_State> {
  Calorie_Cubit() : super(CalorieCubitInitial()) {
    _enableFirestoreOffline();
  }

  void _enableFirestoreOffline() {
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);
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

      if (gender == null ||
          weightKg == 0.0 ||
          heightCm == 0.0 ||
          dailyCalories == 0.0) {
        print(
            "Incomplete data in SharedPreferences, fetching from Firestore...");
        if (gender == null) {
          gender = await _getUserGender(userId);
          print("Fetched Gender from Firestore: $gender");
        }
        if (weightKg == 0.0) {
          weightKg = await _getUserWeight(userId);
          print("Fetched Weight from Firestore: $weightKg");
        }
        if (heightCm == 0.0) {
          heightCm = await _getUserHeight(userId);
          print("Fetched Height from Firestore: $heightCm");
        }
      }

      if (weightKg == 0.0 || heightCm == 0.0) {
        emit(const CalorieCubitError("Please provide your height and weight."));
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

      String goal = await _getUserWeightLossGoal(userId);
      print("Fetched Goal from Firestore: $goal");

      double adjustedCalories = dailyCalories;
      adjustedCalories -= _getCalorieAdjustment(goal);

      await prefs.setDouble('adjusted_calories_$userId', adjustedCalories);

      double proteinGrams =
          _calculateMacronutrientGrams(adjustedCalories, 30, 4); // 35% Protein
      double fatsGrams =
          _calculateMacronutrientGrams(adjustedCalories, 30, 9); // 25% Fats
      double carbsGrams =
          _calculateMacronutrientGrams(adjustedCalories, 40, 4); // 40% Carbs
//change it based on diet and maybe we will change it in future so remember it
      print("Calculated Macronutrients:");
      print("Protein: $proteinGrams grams");
      print("Carbs: $carbsGrams grams");
      print("Fats: $fatsGrams grams");

      await prefs.setDouble('protein_grams_$userId', proteinGrams);
      await prefs.setDouble('carbs_grams_$userId', carbsGrams);
      await prefs.setDouble('fats_grams_$userId', fatsGrams);

      emit(CalorieCubitSuccess(adjustedCalories));
      print("Emission success with adjusted calories: $adjustedCalories");
    } catch (e) {
      emit(CalorieCubitError(e.toString()));
      print("Error occurred: ${e.toString()}");
    }
  }

  double _getCalorieAdjustment(String goal) {
    switch (goal) {
      case "Lose 1 kg per week":
        return 1000;
      case "Lose 0.5 kg per week":
        return 500;
      default:
        return 0;
    }
  }

  double _calculateMacronutrientGrams(
      double adjustedCalories, double percentage, double caloriesPerGram) {
    return (adjustedCalories * (percentage / 100)) / caloriesPerGram;
  }

  Future<void> fetchCalculatedMacronutrients(String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      double? adjustedCalories = prefs.getDouble('adjusted_calories_$userId');

      if (adjustedCalories == null || adjustedCalories == 0.0) {
        emit(const CalorieCubitError("Adjusted calories not found."));
        return;
      }

      print("Adjusted Calories: $adjustedCalories");

      double proteinGrams =
          _calculateMacronutrientGrams(adjustedCalories, 30, 4); // 40% protein
      double carbsGrams =
          _calculateMacronutrientGrams(adjustedCalories, 40, 4); // 35% carbs
      double fatsGrams =
          _calculateMacronutrientGrams(adjustedCalories, 30, 9); // 25% fat

      print("Protein: $proteinGrams grams");
      print("Carbs: $carbsGrams grams");
      print("Fats: $fatsGrams grams");

      await prefs.setDouble('protein_grams_$userId', proteinGrams);
      await prefs.setDouble('carbs_grams_$userId', carbsGrams);
      await prefs.setDouble('fats_grams_$userId', fatsGrams);

      // Emit success state with calculated macronutrients
      emit(CalorieMacronutrientSuccess(proteinGrams, carbsGrams, fatsGrams));
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
