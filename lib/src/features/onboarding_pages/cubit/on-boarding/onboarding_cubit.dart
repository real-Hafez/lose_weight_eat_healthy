import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/cubit/on-boarding/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final PageController _pageController = PageController(initialPage: 12);

  OnboardingCubit() : super(OnboardingState());

  PageController get pageController => _pageController;

  void nextPage() {
    final nextPage = state.currentPage + 1;
    if (nextPage < _getTotalPages()) {
      emit(state.copyWith(currentPage: nextPage, showNextButton: false));
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void showNextButton() {
    emit(state.copyWith(showNextButton: true));
  }

  void changeHeightUnit(String unit) {
    emit(state.copyWith(heightUnit: unit));
  }

  String getCollectionName() {
    return 'collection_name';
  }

  int _getTotalPages() {
    return 15;
  }

  @override
  Future<void> close() {
    _pageController.dispose();
    return super.close();
  }
}
