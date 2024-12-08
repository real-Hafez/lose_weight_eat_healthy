import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService_breakfast {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFoods(double mincal) async {
    try {
      final response = await supabase
          .from('breakfast_middle eastern')
          .select()
          .gte('calories', mincal.toInt())
          .lte('calories', 150)
          .gte('protein', 1)
          .lte('protein', 300);

      print("Query Response: ${response.runtimeType} - $response");

      if (response == null || response.isEmpty) {
        print("No breakfast foods found. Min Calories: $mincal");
        return [];
      }

      List<Map<String, dynamic>> result =
          List<Map<String, dynamic>>.from(response);
      print("Fetched Meals: $result");
      return result;
    } catch (e) {
      print("Error fetching breakfast foods: $e");
      return [];
    }
  }
}
