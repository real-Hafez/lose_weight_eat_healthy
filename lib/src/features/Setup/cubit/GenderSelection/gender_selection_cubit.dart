import 'package:bloc/bloc.dart';

class GenderSelectionCubit extends Cubit<String?> {
  GenderSelectionCubit() : super(null);

  void selectGender(String gender) {
    emit(gender);
  }
}
