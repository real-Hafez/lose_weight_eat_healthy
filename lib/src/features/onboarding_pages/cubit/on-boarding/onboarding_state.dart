class OnboardingState {
  final int currentPage;
  final bool showNextButton;
  final String heightUnit;
  final String selectedOption;

  OnboardingState({
    this.currentPage = 0,
    this.showNextButton = false,
    this.heightUnit = 'cm',
    this.selectedOption = '',
  });

  OnboardingState copyWith({
    int? currentPage,
    bool? showNextButton,
    String? heightUnit,
    String? selectedOption,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      showNextButton: showNextButton ?? this.showNextButton,
      heightUnit: heightUnit ?? this.heightUnit,
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }
}
