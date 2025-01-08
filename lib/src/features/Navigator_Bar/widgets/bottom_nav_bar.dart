import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Navigator_Bar/widgets/nav_bar_items.dart';
import 'package:lose_weight_eat_healthy/src/features/Navigator_Bar/widgets/screens.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 2);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,

      controller: _controller,
      screens: buildScreens(),
      items: navBarsItems(),
      animationSettings: const NavBarAnimationSettings(
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
              animateTabTransition: true,
              screenTransitionAnimationType:
                  ScreenTransitionAnimationType.slide,
              curve: Curves.easeOutExpo)),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      // popAllScreensOnTapOfSelectedTab: true,
      backgroundColor: Colors.black,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(1.0),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style9,
    );
  }
}
