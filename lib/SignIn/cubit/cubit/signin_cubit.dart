import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/auth_servce.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/GoogleSignuP.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthService _authService;

  SigninCubit(this._authService) : super(SigninInitial());

  Future<void> signInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(SigninLoading());
    try {
      await _authService.signin(
        email: email,
        password: password,
        context: context,
      );
      emit(SigninSuccess());
    } catch (e) {
      // Assuming the error message is a string
      String errorMessage =
          e is String ? e : 'Something went wrong. Please try again.';
      print('Sign-in error: $errorMessage');
      emit(SigninFailure(errorMessage));
    }
  }

  Future<void> signInWithGoogle({required BuildContext context}) async {
    emit(SigninSocialSignIn());
    try {
      final user = await Authentication.signInWithGoogle(context: context);
      if (user != null) {
        emit(SigninSuccess());
      } else {
        emit(SigninFailure('Google sign-in failed. Please try again.'));
      }
    } catch (e) {
      print('Google sign-in error: $e');
      emit(SigninFailure('An unexpected error occurred. Please try again.'));
    }
  }
}
