import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reset_password_body.g.dart';

@JsonSerializable()
class ResetPasswordBody extends Equatable {
  @JsonKey(name: 'code')
  final String code;
  @JsonKey(name: 'password')
  final String password;

  ResetPasswordBody({
    required this.code,
    required this.password,
  });

  factory ResetPasswordBody.fromJson(Map<String, dynamic> json) => _$ResetPasswordBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordBodyToJson(this);

  @override
  List<Object?> get props => [
    code,
    password,
  ];

  @override
  String toString() {
    return 'ResetPasswordBody{code: $code, password: $password}';
  }
}
