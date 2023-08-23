part of 'reset_password_bloc.dart';

abstract class ResetPasswordState {}

class InitialResetPasswordState extends ResetPasswordState {}

class LoadingResetPasswordState extends ResetPasswordState {}

class FailureResetPasswordState extends ResetPasswordState {
  final String errorMessage;

  FailureResetPasswordState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureResetPasswordState{errorMessage: $errorMessage}';
  }
}

class SuccessResetPasswordState extends ResetPasswordState {}