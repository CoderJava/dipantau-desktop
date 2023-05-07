import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_up_response.g.dart';

@JsonSerializable()
class SignUpResponse extends Equatable {
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'email')
  final String? email;

  SignUpResponse({
    required this.name,
    required this.email,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) => _$SignUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);

  @override
  List<Object?> get props => [
    name,
    email,
  ];

  @override
  String toString() {
    return 'SignUpResponse{name: $name, email: $email}';
  }
}
