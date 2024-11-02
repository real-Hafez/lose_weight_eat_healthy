import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService_breakfast {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFoods() async {
    try {
      final data = await supabase.from('breakfast_middle eastern').select();

      if (data.isEmpty) {
        print("No breakfast foods found matching the criteria.");
        return [];
      }

      return List<Map<String, dynamic>>.from(data.cast());
    } catch (e) {
      print("Error fetching breakfast foods: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchFromSupabase() async {
    try {
      final response = await supabase
          .from('breakfast_middle eastern')
          .select()
          .limit(1)
          .single(); // Fetch a single meal item

      if (response == null) {
        print("No data found for breakfast from Supabase.");
        return null;
      }

      return Map<String, dynamic>.from(response);
    } catch (e) {
      print("Error fetching data from Supabase: $e");
      return null;
    }
  }
}
