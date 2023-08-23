part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState {}

class InitialForgotPasswordState extends ForgotPasswordState {}

class LoadingForgotPasswordState extends ForgotPasswordState {}

class FailureForgotPasswordState extends ForgotPasswordState {
  final String errorMessage;

  FailureForgotPasswordState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureForgotPasswordState{errorMessage: $errorMessage}';
  }
}

class SuccessForgotPasswordState extends ForgotPasswordState {
  final String email;

  SuccessForgotPasswordState({required this.email});

  @override
  String toString() {
    return 'SuccessForgotPasswordState{email: $email}';
  }
}