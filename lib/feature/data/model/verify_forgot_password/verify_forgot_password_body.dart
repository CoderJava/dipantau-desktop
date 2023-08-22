import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_forgot_password_body.g.dart';

@JsonSerializable()
class VerifyForgotPasswordBody extends Equatable {
  @JsonKey(name: 'code')
  final String code;

  VerifyForgotPasswordBody({required this.code});

  factory VerifyForgotPasswordBody.fromJson(Map<String, dynamic> json) => _$VerifyForgotPasswordBodyFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyForgotPasswordBodyToJson(this);

  @override
  List<Object?> get props => [
    code,
  ];

  @override
  String toString() {
    return 'VerifyForgotPasswordBody{code: $code}';
  }
}