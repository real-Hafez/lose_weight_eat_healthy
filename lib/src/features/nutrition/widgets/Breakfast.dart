import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Breakfast extends StatefulWidget {
  const Breakfast({super.key});

  @override
  _BreakfastState createState() => _BreakfastState();
}

class _BreakfastState extends State<Breakfast> {
  final FoodService_breakfast foodService = FoodService_breakfast();
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<Map<String, dynamic>?> closestBreakfastMeal;

  @override
  void initState() {
    super.initState();
    closestBreakfastMeal = _loadClosestMeal();
  }

  Future<Map<String, dynamic>?> _loadClosestMeal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Get user macros
    double targetCalories = prefs.getDouble('adjusted_calories_$userId') ?? 0.0;
    double targetProtein = prefs.getDouble('protein_grams_$userId') ?? 0.0;
    double targetCarbs = prefs.getDouble('carbs_grams_$userId') ?? 0.0;
    double targetFats = prefs.getDouble('fats_grams_$userId') ?? 0.0;

    // Fetch food data from the service
    List<Map<String, dynamic>> foods = await foodService.getFoods();

    // Fetch the closest meal
    return await MealService().getClosestMeal(
        targetCalories, targetProtein, targetCarbs, targetFats, foods);
  }

  // Fetch user ID
  Future<String> getUserId() async {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  // Fetch the user's diet preference from Firestore
  Future<String> getUserDietFromFirebase() async {
    try {
      final userId = await getUserId();
      if (userId.isEmpty) throw Exception('No user logged in');

      DocumentSnapshot dietSnapshot = await FirebaseFirestore.instance
          .doc('/users/$userId/Diet/data')
          .get();

      return dietSnapshot.exists ? dietSnapshot['selectedGender'] : 'Anything';
    } catch (e) {
      print('Error fetching user diet: $e');
      return 'Anything';
    }
  }

  // Fetch the user's disliked foods from Firestore
  Future<List<String>> getUserDislikedFoodsFromFirebase() async {
    try {
      final userId = await getUserId();
      if (userId.isEmpty) throw Exception('No user logged in');

      DocumentSnapshot dishSnapshot = await FirebaseFirestore.instance
          .doc('/users/$userId/Dish/data')
          .get();

      return dishSnapshot.exists
          ? List<String>.from(dishSnapshot['selectedDishes'])
          : [];
    } catch (e) {
      print('Error fetching disliked foods: $e');
      return [];
    }
  }

  // Fetch breakfast data directly from Supabase
  Future<List<Map<String, dynamic>>> getBreakfastData() async {
    print("Fetch breakfast data from Supabase");
    List<Map<String, dynamic>> foods = await foodService.getFoods();
    return foods;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: closestBreakfastMeal,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No suitable breakfast found'));
        } else {
          var meal = snapshot.data!;
          return NutritionInfoCard(
            foodName: meal['food_Name_Arabic'] ?? 'Unknown',
            foodImage: meal['food_Image'],
            calories: meal['calories'],
            weight: meal['weight'],
            fat: meal['fat'],
            carbs: meal['carbs'] ?? 0,
            protein: meal['protein'],
          );
        }
      },
    );
  }
}
