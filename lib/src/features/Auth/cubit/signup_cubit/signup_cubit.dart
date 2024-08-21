import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/service/AuthService.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/service/Googleauthservice.dart';

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
      if (e is String) {
        emit(SignupFailure(e));
      } else {
        emit(SignupFailure('Something went wrong. Please try again.'));
      }
    }
  }

  Future<void> signInWithGoogle({required BuildContext context}) async {
    emit(SignupSocialSignIn());
    try {
      final user = await Googleauthservice.signInWithGoogle(context: context);
      if (user != null) {
        emit(SignupSuccess());
      } else {
        emit(SignupFailure('Google sign-in failed. Please try again.'));
      }
    } catch (e) {
      emit(SignupFailure('An unexpected error occurred. Please try again.'));
    }
  }
}
