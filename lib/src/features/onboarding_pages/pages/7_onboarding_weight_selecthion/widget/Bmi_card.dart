import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/widget/helper/BmiHelper.dart';
import 'package:lose_weight_eat_healthy/src/localization/LocaleCubit/LocaleCubit.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';

class Bmi_Card extends StatelessWidget {
  final double bmiValue;
  const Bmi_Card({super.key, required this.bmiValue});

  @override
  Widget build(BuildContext context) {
    final bool isArabic =
        context.read<LocaleCubit>().state.languageCode == 'ar';
    final bmiDetails = BmiHelper.getBmiDetails(bmiValue);
    final String bmiStatus = bmiDetails['bmiStatus'];
    final String recommendation = bmiDetails['recommendation'];
    final Color statusColor = bmiDetails['statusColor'];
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenHeight * 0.02),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.blue.shade300],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title at the top
          Text(
            S().Bmi,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          // Circular Container for BMI Value and Status
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: screenHeight * 0.18,
                height: screenHeight * 0.18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    isArabic
                        ? NumberConversionHelper.convertToArabicNumbers(
                            bmiValue.toStringAsFixed(1))
                        : bmiValue.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: screenHeight * 0.04,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    bmiStatus,
                    style: TextStyle(
                      fontSize: screenHeight * 0.016,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.03),

          // Recommendation Section at Bottom
          Container(
            padding: EdgeInsets.all(screenHeight * 0.020),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.favorite,
                    color: statusColor, size: screenWidth * 0.07),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: AutoSizeText(
                    recommendation,
                    softWrap: true,
                    wrapWords: true,
                    style: TextStyle(
                      fontSize: screenHeight * 0.020,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
