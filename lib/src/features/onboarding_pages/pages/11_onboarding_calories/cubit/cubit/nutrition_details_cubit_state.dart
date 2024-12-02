import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class NutritionState {
  final String selectedDiet;
  final double customProtein;
  final double customCarbs;
  final double customFat;

  NutritionState({
    required this.selectedDiet,
    required this.customProtein,
    required this.customCarbs,
    required this.customFat,
  });

  NutritionState copyWith({
    String? selectedDiet,
    double? customProtein,
    double? customCarbs,
    double? customFat,
  }) {
    return NutritionState(
      selectedDiet: selectedDiet ?? this.selectedDiet,
      customProtein: customProtein ?? this.customProtein,
      customCarbs: customCarbs ?? this.customCarbs,
      customFat: customFat ?? this.customFat,
    );
  }
}
