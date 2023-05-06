part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class InitialLoginState extends LoginState {}

class LoadingLoginState extends LoginState {}

class FailureLoginState extends LoginState {
  final String errorMessage;

  FailureLoginState({required this.errorMessage});

  @override
  List<Object?> get props => [
    errorMessage,
  ];

  @override
  String toString() {
    return 'FailureLoginState{errorMessage: $errorMessage}';
  }
}

class SuccessSubmitLoginState extends LoginState {}