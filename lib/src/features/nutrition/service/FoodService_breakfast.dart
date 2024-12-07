import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService_breakfast {
  final supabase = Supabase.instance.client;

  /// Fetch all foods from the `breakfast_middle eastern` table.
  Future<List<Map<String, dynamic>>> getFoods() async {
    try {
      final response = await supabase
          .from('breakfast_middle eastern')
          .select()
          .gte('calories', 130) // Filter: calories >= 400
          .lte('calories', 170)
          .gte('protein', 9)
          .lte('protein', 300);

      if (response == null || response.isEmpty) {
        print("No breakfast foods found.");
        return [];
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching breakfast foods: $e");
      return [];
    }
  }

  /// Fetch foods filtered by calorie range from the `breakfast_middle eastern` table.
  Future<List<Map<String, dynamic>>> fetchFromSupabase() async {
    try {
      final response = await supabase
          .from('breakfasts_middle eastern')
          .select()
          .gte('calories', 400) // Filter: calories >= 400
          .lte('calories', 500); // Filter: calories <= 500;

      if (response == null || response.isEmpty) {
        print("No breakfast foods found in the specified range.");
        return [];
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching filtered breakfast foods: $e");
      return [];
    }
  }
}
