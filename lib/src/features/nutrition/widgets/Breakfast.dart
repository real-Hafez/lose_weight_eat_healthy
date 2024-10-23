import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Breakfast extends StatefulWidget {
  const Breakfast({super.key});

  @override
  _BreakfastState createState() => _BreakfastState();
}

class _BreakfastState extends State<Breakfast> {
  final FoodService_breakfast foodService = FoodService_breakfast();
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getBreakfastData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: AppLoadingIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No breakfast items available'));
        } else {
          return FutureBuilder<String>(
            future: getUserDietFromFirebase(),
            builder: (context, dietSnapshot) {
              if (dietSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: AppLoadingIndicator());
              } else if (dietSnapshot.hasError) {
                return Center(child: Text('Error: ${dietSnapshot.error}'));
              }

              String userDiet = dietSnapshot.data ?? 'Anything';

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
                        child: Text('No suitable breakfast items found'));
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
