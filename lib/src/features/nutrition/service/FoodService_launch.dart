import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService_launch {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFoods() async {
    try {
      final data = await supabase
          .from(
            'lunch_meals_for_Arabic_Country',
          )
          .select();

      if (data.isEmpty) {
        print("No foods found matching the criteria.");
        return [];
      }

      for (var food in data) {}

      return List<Map<String, dynamic>>.from(data.cast());
    } catch (e) {
      print("Error fetching foods: $e");
      return [];
    }
  }
}
