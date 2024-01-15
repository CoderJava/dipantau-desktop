import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_up_by_user_body.g.dart';

@JsonSerializable()
class SignUpByUserBody extends Equatable {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;

  SignUpByUserBody({
    required this.name,
    required this.email,
    required this.password,
  });

  factory SignUpByUserBody.fromJson(Map<String, dynamic> json) => _$SignUpByUserBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpByUserBodyToJson(this);

  @override
  List<Object?> get props => [
    name,
    email,
    password,
  ];

  @override
  String toString() {
    return 'SignUpByUserBody{name: $name, email: $email, password: $password}';
  }
}
