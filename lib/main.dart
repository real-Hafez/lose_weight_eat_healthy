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
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/ffifthOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/fourthOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/secondOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/thirdOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/setup.dart';
import 'package:lose_weight_eat_healthy/src/features/splash/pages/Splash_Screen.dart';
import 'package:lose_weight_eat_healthy/src/localization/LocaleCubit/LocaleCubit.dart';
import 'package:lose_weight_eat_healthy/src/theme/dark_Theme.dart';
import 'package:lose_weight_eat_healthy/src/theme/light_Theme.dart';

import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
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
          create: (context) => SigninCubit(AuthService()),
        ),
        BlocProvider(
          create: (context) => LocaleCubit(),
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
            home: const setup(),
          );
        },
      ),
    );
  }
}
