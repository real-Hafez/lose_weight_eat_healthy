import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';

class BmiHelper {
  static Map<String, dynamic> getBmiDetails(double bmiValue) {
    String bmiStatus = S().normalWeight;
    String recommendation = S().healthylifestyle;
    Color statusColor = Colors.green;

    if (bmiValue < 16) {
      bmiStatus = S().severeThinness;
      recommendation = S().severeThinnessRec;
      statusColor = Colors.purple;
    } else if (bmiValue >= 16 && bmiValue < 17) {
      bmiStatus = S().moderateThinness;
      recommendation = S().moderateThinnessRec;
      statusColor = Colors.orange;
    } else if (bmiValue >= 17 && bmiValue < 18.5) {
      bmiStatus = S().mildThinness;
      recommendation = S().mildThinnessRec;
      statusColor = Colors.yellow;
    } else if (bmiValue >= 18.5 && bmiValue < 25) {
      bmiStatus = S().normalWeight;
      recommendation = S().normalRec;
      statusColor = Colors.green;
    } else if (bmiValue >= 25 && bmiValue < 30) {
      bmiStatus = S().overweight;
      recommendation = S().overweightRec;
      statusColor = Colors.orangeAccent;
    } else if (bmiValue >= 30 && bmiValue < 35) {
      bmiStatus = S().obeseClassI;
      recommendation = S().obeseClassIRec;
      statusColor = Colors.redAccent;
    } else if (bmiValue >= 35 && bmiValue < 40) {
      bmiStatus = S().obeseClassII;
      recommendation = S().obeseClassIIRec;
      statusColor = Colors.red;
    } else if (bmiValue >= 40) {
      bmiStatus = S().obeseClassIII;
      recommendation = S().obeseClassIIIRec;
      statusColor = Colors.deepOrange;
    }

    return {
      'bmiStatus': bmiStatus,
      'recommendation': recommendation,
      'statusColor': statusColor,
    };
  }
}
