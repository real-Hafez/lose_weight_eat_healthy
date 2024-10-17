import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert'; // To handle JSON encoding/decoding

class Lunch extends StatefulWidget {
  const Lunch({super.key});

  @override
  _LunchState createState() => _LunchState();
}

class _LunchState extends State<Lunch> {
  final FoodService_launch foodService = FoodService_launch();
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    clearFoodDataAtEndOfDay(); // Clear food data at the start of the day.
  }

  // Method to clear food data if it's a new day
  Future<void> clearFoodDataAtEndOfDay() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastSavedDate = prefs.getString('lastSavedDate');
    String todayDate = DateTime.now()
        .toIso8601String()
        .split('T')
        .first; // Get only the date part

    if (lastSavedDate != todayDate) {
      // It's a new day, clear food data
      await prefs.remove('savedFoodData');
      await prefs.setString('lastSavedDate', todayDate);
      print("Cleared food data for a new day.");
    }
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

      return dietSnapshot.exists
          ? dietSnapshot['selectedGender']
          : 'Everything';
    } catch (e) {
      print('Error fetching user diet: $e');
      return 'Everything';
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

  // Fetch food data from SharedPreferences or Supabase
  // Fetch food data from SharedPreferences or Supabase
  Future<List<Map<String, dynamic>>> getFoodData() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedFoodData = prefs.getString('savedFoodData');

    if (savedFoodData != null) {
      print("Get from SharedPreferences");
      List<Map<String, dynamic>> foodData =
          List<Map<String, dynamic>>.from(json.decode(savedFoodData));
      print("Retrieved food data: $foodData");
      return foodData;
    } else {
      print("Fetch from Supabase");
      List<Map<String, dynamic>> foods = await foodService.getFoods();
      if (foods.isNotEmpty) {
        await prefs.setString('savedFoodData', json.encode(foods));
        print("Data fetched from Supabase and saved to SharedPreferences");
      } else {
        print("No food data fetched from Supabase");
      }
      return foods;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getFoodData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: AppLoadingIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No food items available'));
        } else {
          return FutureBuilder<String>(
            future: getUserDietFromFirebase(),
            builder: (context, dietSnapshot) {
              if (dietSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: AppLoadingIndicator());
              } else if (dietSnapshot.hasError) {
                return Center(child: Text('Error: ${dietSnapshot.error}'));
              }

              String userDiet = dietSnapshot.data ?? 'Everything';

              return FutureBuilder<List<String>>(
                future: getUserDislikedFoodsFromFirebase(),
                builder: (context, dislikedFoodsSnapshot) {
                  if (dislikedFoodsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: AppLoadingIndicator());
                  } else if (dislikedFoodsSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${dislikedFoodsSnapshot.error}'));
                  }

                  List<String> dislikedFoods = dislikedFoodsSnapshot.data ?? [];

                  List<Map<String, dynamic>> filteredFoods =
                      snapshot.data!.where((food) {
                    bool isSuitableForDiet =
                        food['Tags']?.contains(userDiet) ?? true;
                    bool isDisliked = dislikedFoods.contains(food['food_Name']);
                    return isSuitableForDiet && !isDisliked;
                  }).toList();

                  if (filteredFoods.isEmpty) {
                    return const Center(
                        child: Text('No suitable food items found'));
                  }

                  var food = filteredFoods[0];

                  return NutritionInfoCard(
                    foodName: food['food_Name'] ?? 'Unknown',
                    foodImage:
                        food['food_Image'] ?? 'https://via.placeholder.com/150',
                    calories: food['calories'] ?? 0,
                    weight: food['weight'] ?? 0,
                    fat: food['fat'] ?? 0,
                    carbs: food['carbs'] ?? 0,
                    protein: food['protein'] ?? 0,
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
