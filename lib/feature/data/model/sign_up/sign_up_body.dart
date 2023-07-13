import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_up_body.g.dart';

@JsonSerializable()
class SignUpBody extends Equatable {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  @JsonKey(name: 'user_role', toJson: _userRoleToJson)
  final UserRole userRole;

  SignUpBody({
    required this.name,
    required this.email,
    required this.password,
    required this.userRole,
  });

  factory SignUpBody.fromJson(Map<String, dynamic> json) => _$SignUpBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpBodyToJson(this);

  static String _userRoleToJson(UserRole value) {
    switch (value) {
      case UserRole.superAdmin:
        return 'super_admin';
      case UserRole.admin:
        return 'admin';
      case UserRole.employee:
        return 'employee';
    }
  }

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        userRole,
      ];

  @override
  String toString() {
    return 'SignUpBody{name: $name, email: $email, password: $password, userRole: $userRole}';
  }
}
