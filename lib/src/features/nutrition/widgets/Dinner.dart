import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class Dinner extends StatefulWidget {
  const Dinner({super.key});

  @override
  _DinnerState createState() => _DinnerState();
}

class _DinnerState extends State<Dinner> {
  final FoodService_Dinner foodService = FoodService_Dinner();
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    clearFoodDataAtEndOfDay();
  }

  Future<void> clearFoodDataAtEndOfDay() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastSavedDate = prefs.getString('lastSavedDate');
    String todayDate = DateTime.now().toIso8601String().split('T').first;

    if (lastSavedDate != todayDate) {
      await prefs.remove('savedDinnerData');
      await prefs.setString('lastSavedDate', todayDate);
      print("Cleared dinner data for a new day.");
    }
  }

  Future<String> getUserId() async {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

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

  Future<List<Map<String, dynamic>>> getDinnerData() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedDinnerData = prefs.getString('savedDinnerData');

    if (savedDinnerData != null) {
      print("Dinner retrieved from SharedPreferences");
      List<Map<String, dynamic>> dinnerData =
          List<Map<String, dynamic>>.from(json.decode(savedDinnerData));
      print("Retrieved dinner data: $dinnerData");
      return dinnerData;
    } else {
      print("Fetching dinner from Supabase");
      List<Map<String, dynamic>> dinners = await foodService.getFoods();
      if (dinners.isNotEmpty) {
        await prefs.setString('savedDinnerData', json.encode(dinners));
        print(
            "Dinner data fetched from Supabase and saved to SharedPreferences");
      } else {
        print("No dinner data fetched from Supabase");
      }
      return dinners;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getDinnerData(),
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
