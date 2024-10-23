/*
  This function fetches food data by first checking if it's available in the local storage (SharedPreferences).
  1. It checks for saved food data in SharedPreferences:
     - If data exists:
       - It decodes the JSON data stored in SharedPreferences.
       - Returns the decoded data, which is a list of food items.
     - If no data is found:
       - It fetches the food data from the Supabase database via an API call.
       - If the API call is successful and returns data:
         - The fetched data is saved to SharedPreferences to avoid future network calls.
       - Whether or not data is fetched from Supabase, the function returns it as a list. 
       and then save the data to shared pre and when open app next time he will see the food untill new 
       Day coming get the new food from supabase ...
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  }

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

  Future<List<Map<String, dynamic>>> getFoodData() async {
    print("Fetch from Supabase");
    List<Map<String, dynamic>> foods = await foodService.getFoods();
    if (foods.isNotEmpty) {
      print("Data fetched from Supabase");
    } else {
      print("No food data fetched from Supabase");
    }
    return foods;
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
                    foodName: food['food_Name_Arabic'] ?? 'Unknown',
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
