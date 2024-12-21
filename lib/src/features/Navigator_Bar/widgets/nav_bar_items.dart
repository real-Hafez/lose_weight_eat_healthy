import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

List<PersistentBottomNavBarItem> navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      title: ("${S().Home}"),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.water),
      title: ("${S().water}"),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.food_bank_outlined),
      title: ("${S().nutrition}"),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.settings),
      title: ("${S().setting}"),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.grey,
    ),
  ];
}
