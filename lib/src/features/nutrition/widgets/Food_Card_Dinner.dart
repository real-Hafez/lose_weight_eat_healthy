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
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Dinner.dart';

class Food_Card_Dinner extends StatelessWidget {
  const Food_Card_Dinner({super.key});

  @override
  Widget build(BuildContext context) {
    return Dinner();
  }
}
