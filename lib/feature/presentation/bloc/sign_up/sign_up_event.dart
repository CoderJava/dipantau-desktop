part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class SubmitSignUpEvent extends SignUpEvent {
  final SignUpBody body;

  SubmitSignUpEvent({required this.body});

  @override
  List<Object?> get props => [
    body,
  ];

  @override
  String toString() {
    return 'SubmitSignUpEvent{body: $body}';
  }
}