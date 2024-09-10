import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/on-boarding/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final PageController _pageController = PageController();

  OnboardingCubit() : super(OnboardingState());

  PageController get pageController => _pageController;

  void nextPage() {
    final nextPage = state.currentPage + 1;
    if (nextPage < _getTotalPages()) {
      // Move to the next page and hide the "Next" button initially
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
    // Implement your logic to get the collection name
    return 'collection_name';
  }

  int _getTotalPages() {
    return 8;
  }

  @override
  Future<void> close() {
    _pageController.dispose();
    return super.close();
  }
}
