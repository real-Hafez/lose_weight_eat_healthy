import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFoods() async {
    try {
      final data = await supabase
          .from(
            'breakfast_meals',
          )
          .select();

      // Check if the data is empty
      if (data.isEmpty) {
        print("No foods found matching the criteria.");
        return [];
      }

      // Print the number of documents retrieved
      print("Documents found: ${data.length}");

      // Print each food item found
      for (var food in data) {
        print("Food Item: $food");
      }

      // Map the response data to List<Map<String, dynamic>>
      return List<Map<String, dynamic>>.from(data.cast());
    } catch (e) {
      print("Error fetching foods: $e");
      return [];
    }
  }
}
