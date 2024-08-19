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
      _handleSignInSuccess(context);
    } catch (e) {
      // Logging the error for developers
      print('Sign-in error: $e');
      emit(SigninFailure('Something went wrong. Please try again.'));
    }
  }

  Future<void> signInWithGoogle({required BuildContext context}) async {
    emit(SigninSocialSignIn());
    try {
      final user = await Authentication.signInWithGoogle(context: context);
      if (user != null) {
        emit(SigninSuccess());
        _handleSignInSuccess(context);
      } else {
        emit(SigninFailure('Google sign-in failed. Please try again.'));
      }
    } catch (e) {
      // Logging the error for developers
      print('Google sign-in error: $e');
      emit(SigninFailure('An unexpected error occurred. Please try again.'));
    }
  }

  void _handleSignInSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Welcome back!')),
    );
    Navigator.of(context).pushReplacementNamed('/anotherHome');
  }
}
