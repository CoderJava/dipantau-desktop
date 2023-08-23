part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent {}

class SubmitResetPasswordEvent extends ResetPasswordEvent {
  final ResetPasswordBody body;

  SubmitResetPasswordEvent({required this.body});

  @override
  String toString() {
    return 'SubmitResetPasswordEvent{body: $body}';
  }
}