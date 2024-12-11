import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/Routes/app_routes.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/cubit/login_cubit/signin_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/service/AuthService.dart';
import 'package:lose_weight_eat_healthy/firebase_options.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/cubit/signup_cubit/signup_cubit.dart'; // Import your cubit
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Day_page/Breakfast/cubit/breakfast_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Day_page/Lunch/cubit/lunch_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Day_page/dinner/cubit/dinner_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/calories_chart_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/nutrition_details_cubit_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/3_onboarding_gender_selecthion/cubit/GenderSelection/gender_selection_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/cubit/on-boarding/onboarding_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/cubit/water/water_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/cubit/calorie_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/cubit/cubit/mealfinder_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/cubit/cubit/weight_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/splash/pages/Splash_Screen.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/localization/LocaleCubit/LocaleCubit.dart';
import 'package:lose_weight_eat_healthy/src/theme/dark_Theme.dart';
import 'package:lose_weight_eat_healthy/src/theme/light_Theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
      url: 'https://icobobugrotssbzwnilc.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imljb2JvYnVncm90c3NienduaWxjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc4NjU2NzQsImV4cCI6MjA0MzQ0MTY3NH0.xmV_dP0nTiCVppIGwr5CLPo5Ln_QVbMbnoGaUDtZHN4');

  // final mealFinder = MealFinder();
  // await mealFinder.findMeals();

  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignupCubit(AuthService()),
        ),
        BlocProvider(
          create: (context) => CalorieCubit(),
        ),
        BlocProvider(
          create: (context) => SigninCubit(AuthService()),
        ),
        BlocProvider(
          create: (context) => LocaleCubit(),
        ),
        BlocProvider(
          create: (context) => OnboardingCubit(),
        ),
        BlocProvider(
          create: (context) => GenderSelectionCubit(),
        ),
        BlocProvider(
          create: (context) => WeightGoalCubit(),
        ),
        BlocProvider(
          create: (context) => WaterCubit(),
        ),
        BlocProvider(
          create: (context) => WaterBloc(),
        ),
        BlocProvider(
          create: (context) => WeightCubit(),
        ),
        BlocProvider<NutritionCubit>(
          create: (_) =>
              NutritionCubit(2500), // Pass initial calories, e.g., 2000
        ),
        BlocProvider<CaloriesChartCubit>(
          create: (_) => CaloriesChartCubit(),
        ),
        BlocProvider(create: (_) => BreakfastCubit()),
        BlocProvider(create: (_) => Lunchcubit()),
        BlocProvider(create: (_) => Dinner_cubit()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              //testnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: locale,
            initialRoute: AppRoutes.signUpAndLogin,
            onGenerateRoute: AppRoutes.generateRoute,
            builder: DevicePreview.appBuilder,
            themeMode: ThemeMode.system,
            theme: light_theme,
            darkTheme: dark_theme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
