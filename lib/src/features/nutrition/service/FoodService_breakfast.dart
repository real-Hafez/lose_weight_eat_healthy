import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService_breakfast {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFoods(
    double mincal,
    double maxcal, {
    List<String> excludeMeals = const [],
  }) async {
    try {
      final response = await supabase
          .from('breakfast_middle eastern')
          .select()
          .gte('calories', mincal.toInt())
          .lte('calories', maxcal.toInt());

      if (response.isEmpty) {
        print("No breakfast foods found. Min Calories: $mincal");
        return [];
      }

      List<Map<String, dynamic>> result =
          List<Map<String, dynamic>>.from(response);
      return result;
    } catch (e) {
      print("Error fetching breakfast foods: $e");
      return [];
    }
  }
}
