part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class InitialSignUpState extends SignUpState {}

class LoadingSignUpState extends SignUpState {}

class FailureSignUpState extends SignUpState {
  final String errorMessage;

  FailureSignUpState({required this.errorMessage});

  @override
  List<Object?> get props => [
    errorMessage,
  ];

  @override
  String toString() {
    return 'FailureSignUpState{errorMessage: $errorMessage}';
  }
}

class SuccessSubmitSignUpState extends SignUpState {
  final SignUpResponse response;

  SuccessSubmitSignUpState({required this.response});

  @override
  List<Object?> get props => [
    response,
  ];

  @override
  String toString() {
    return 'SuccessSubmitSignUpState{response: $response}';
  }
}