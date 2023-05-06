import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_body.g.dart';

@JsonSerializable()
class LoginBody extends Equatable {
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'password')
  final String password;

  LoginBody({
    required this.username,
    required this.password,
  });

  factory LoginBody.fromJson(Map<String, dynamic> json) => _$LoginBodyFromJson(json);

  Map<String, dynamic> toJson() => _$LoginBodyToJson(this);

  @override
  List<Object?> get props => [
    username,
    password,
  ];

  @override
  String toString() {
    return 'LoginBody{username: $username, password: $password}';
  }
}
