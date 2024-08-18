import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/auth_servce.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/GoogleSignuP.dart';

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
      _handleSignupSuccess(context);
    } catch (e) {
      // Logging the error for developers
      print('Signup error: $e');
      emit(SignupFailure('Something went wrong. Please try again.'));
    }
  }

  Future<void> signInWithGoogle({required BuildContext context}) async {
    emit(SignupSocialSignIn());
    try {
      final user = await Authentication.signInWithGoogle(context: context);
      if (user != null) {
        emit(SignupSuccess());
        _handleSignupSuccess(context);
      } else {
        emit(SignupFailure('Google sign-in failed. Please try again.'));
      }
    } catch (e) {
      // Logging the error for developers
      print('Google sign-in error: $e');
      emit(SignupFailure('An unexpected error occurred. Please try again.'));
    }
  }

  void _handleSignupSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created successfully')),
    );
    Navigator.of(context).pushReplacementNamed('/toquthions');
  }
}
