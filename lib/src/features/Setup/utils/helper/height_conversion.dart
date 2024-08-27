
void convertCmToFtInches(int cm, Function(int, int) onUpdate) {
  double totalInches = cm / 2.54;
  int feet = (totalInches / 12).floor();
  int inches = (totalInches % 12).round();
  onUpdate(feet, inches);
}

int convertFtInchesToCm(int feet, int inches) {
  int totalInches = (feet * 12) + inches;
  return (totalInches * 2.54).round();
}