import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/auth_servce.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthService _authService;

  SignupCubit(this._authService) : super(SignupInitial());

  Future<void> signupUser({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(SignupLoading());
    try {
      await _authService.signup(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password: password,
        context: context,
      );

      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
