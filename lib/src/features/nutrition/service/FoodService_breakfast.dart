import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService_breakfast {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFoods() async {
    try {
      final data = await supabase
          .from(
            'breakfast_meals',
          )
          .select();

      if (data.isEmpty) {
        print("No breakfast foods found matching the criteria.");
        return [];
      }

      print("Documents found: ${data.length}");

      for (var food in data) {
        print("Breakfast Food Item: $food");
      }

      return List<Map<String, dynamic>>.from(data.cast());
    } catch (e) {
      print("Error fetching breakfast foods: $e");
      return [];
    }
  }
}