import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Home/pages/Home_page.dart';
import 'package:lose_weight_eat_healthy/src/features/Settings/pages/setting.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/pages/nutrition.dart';
import 'package:lose_weight_eat_healthy/src/features/water/pages/water.dart';

List<Widget> buildScreens() {
  return [
    const HomeScreen(),
    const Water(),
    const Nutrition(),
    const setting(),
  ];
}
