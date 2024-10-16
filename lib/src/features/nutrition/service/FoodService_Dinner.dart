import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService_Dinner {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFoods() async {
    try {
      final data = await supabase
          .from(
            'Dinner_meals',
          )
          .select();

      if (data.isEmpty) {
        print("No foods found matching the criteria.");
        return [];
      }

      print("Documents found: ${data.length}");

      for (var food in data) {
        print("Food Item: $food");
      }

      return List<Map<String, dynamic>>.from(data.cast());
    } catch (e) {
      print("Error fetching foods: $e");
      return [];
    }
  }
}
