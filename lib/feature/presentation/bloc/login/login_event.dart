part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class SubmitLoginEvent extends LoginEvent {
  final LoginBody body;

  SubmitLoginEvent({required this.body});

  @override
  List<Object?> get props => [
    body,
  ];

  @override
  String toString() {
    return 'SubmitLoginEvent{body: $body}';
  }
}