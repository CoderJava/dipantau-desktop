import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_body.g.dart';

@JsonSerializable()
class ForgotPasswordBody extends Equatable {
  @JsonKey(name: 'email')
  final String email;

  ForgotPasswordBody({required this.email});

  factory ForgotPasswordBody.fromJson(Map<String, dynamic> json) => _$ForgotPasswordBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordBodyToJson(this);

  @override
  List<Object?> get props => [
    email,
  ];

  @override
  String toString() {
    return 'ForgotPasswordBody{email: $email}';
  }
}