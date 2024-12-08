// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
// import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
// import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';
// import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealFinder.dart';
// import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealService.dart';
// import 'package:lose_weight_eat_healthy/src/features/nutrition/service/Snacks_Service.dart';

// part 'mealfinder_state.dart';

// class MealfinderCubit extends Cubit<MealfinderState> {
//   MealfinderCubit() : super(MealfinderInitial());

//   // final MealFinder mealFinder = MealFinder(
//   //   foodServiceBreakfast: FoodService_breakfast(),
//   //   foodServiceLunch: FoodService_launch(),
//   //   foodServiceDinner: FoodService_Dinner(),
//   //   foodServiceSnacks: FoodService_snacks(),
//   //   mealService: MealService(),
//   // );

//   Future<void> fetchMeals(double targetCalories) async {
//     print('Evaluating meal: $mealFinder');
//     print('Target: Calories=$targetCalories, Protein=');
//     print('Selected meal: ');

//     // Add targetCalories as a parameter
//     emit(MealfinderLoading()); // Emit loading state

//     try {
//       final meals =
//           await mealFinder.findMeals(targetCalories); // Pass targetCalories
//       emit(MealfinderLoaded(meals)); // Emit loaded state with meals
//     } catch (error) {
//       emit(const MealfinderError("Failed to load meals")); // Emit error state
//     }
//   }
// }
