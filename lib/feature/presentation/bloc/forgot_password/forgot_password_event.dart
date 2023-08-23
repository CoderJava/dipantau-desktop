part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent {}

class SubmitForgotPasswordEvent extends ForgotPasswordEvent {
  final ForgotPasswordBody body;

  SubmitForgotPasswordEvent({required this.body});

  @override
  String toString() {
    return 'SubmitForgotPasswordEvent{body: $body}';
  }
}