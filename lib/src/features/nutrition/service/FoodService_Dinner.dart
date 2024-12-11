import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService_Dinner {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFoods(double mincal, maxcal, minprotein,
      maxprotein, mincarb, maxcarb, minfat, maxfat) async {
    try {
      final data = await supabase
          .from(
            'dinner_middle eastern',
          )
          .select()
          .gte('calories', mincal.toInt())
          .lte('calories', maxcal.toInt())
          .gte('protein', minprotein.toInt())
          .lte('protein', maxprotein.toInt())
          .gte('carbs', mincarb.toInt())
          .lte('carbs', maxcarb.toInt())
          .gt('fat', minfat.toInt())
          .lte('fat', maxfat.toInt());

      if (data.isEmpty) {
        print("No foods found matching the criteria.");
        return [];
      }

      for (var food in data) {}

      return List<Map<String, dynamic>>.from(data.cast());
    } catch (e) {
      // print("Error fetching foods: $e");
      return [];
    }
  }
}
