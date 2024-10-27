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
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/GenderSelection/gender_selection_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/on-boarding/onboarding_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/water/water_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/cubit/calorie_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/cubit/cubit/mealfinder_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Mealview/screen/mealview.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealFinder.dart';
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
          create: (context) => MealfinderCubit(),
        ),
        BlocProvider(
          create: (context) => SignupCubit(AuthService()),
        ),
        BlocProvider(
          create: (context) => Calorie_Cubit(),
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
          create: (context) => WaterCubit(),
        ),
        BlocProvider(
          create: (context) => WaterBloc(),
        ),
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
              //test
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: locale,
            initialRoute: AppRoutes.signUpAndLogin,
            onGenerateRoute: AppRoutes.generateRoute,
            builder: DevicePreview.appBuilder,
            themeMode: ThemeMode.system,
            theme: light_theme,
            darkTheme: dark_theme,
            // home: const Splash_Screen(),
            home: Mealview(
                foodImage:
                    'https://www.eatingwell.com/thmb/VqKostZeQfIVieTm9jkOOnkqQZk=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/45495781-216464daa160453bb307d31607564c9c.jpg',
                foodName: "فول بالزيت الحار",
                calories: 10,
                weight: 100,
                fat: 10,
                carbs: 25,
                protein: 35),
            // home: const DietType(),
          );
        },
      ),
    );
  }
}
