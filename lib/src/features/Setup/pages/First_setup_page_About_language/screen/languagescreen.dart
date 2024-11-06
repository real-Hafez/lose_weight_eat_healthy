import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/GenderBox.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';
import 'package:lose_weight_eat_healthy/src/localization/LocaleCubit/LocaleCubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  Widget build(BuildContext context) {
    // Get the device locale
    final deviceLocale = Localizations.localeOf(context).languageCode;

    // Set the default language
    String initialLanguage = deviceLocale == 'ar'
        ? 'ar'
        : 'en'; // Default to 'en' if the locale isn't Arabic or English

    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        // Set the selected language based on the current locale
        final String selectedLanguage =
            locale.languageCode.isEmpty ? initialLanguage : locale.languageCode;

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ProgressIndicatorWidget(value: 0.2),
                const Spacer(),
                Center(
                  child: AutoSizeText(
                    S().preferlanguage,
                    maxFontSize: 28,
                    minFontSize: 14,
                    wrapWords: true,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).height * .03,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GenderBox(
                          gender: S().arabic,
                          countryFlag: CountryFlag.fromCountryCode(
                            'Sa',
                            height: MediaQuery.sizeOf(context).height * .1,
                            width: MediaQuery.sizeOf(context).width * .5,
                          ),
                          isSelected: selectedLanguage == 'ar',
                          onTap: () {
                            // Update the locale to Arabic
                            context
                                .read<LocaleCubit>()
                                .updateLocale(Locale('ar', 'SA'));
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GenderBox(
                          gender: S().english,
                          countryFlag: CountryFlag.fromLanguageCode(
                            'en',
                            height: MediaQuery.sizeOf(context).height * .1,
                            width: MediaQuery.sizeOf(context).width * .5,
                          ),
                          isSelected: selectedLanguage == 'en',
                          onTap: () {
                            // Update the locale to English
                            context
                                .read<LocaleCubit>()
                                .updateLocale(Locale('en', 'US'));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                NextButton(
                  onPressed: onNextButtonPressed,
                  saveData: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
