import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_user_body.g.dart';

@JsonSerializable()
class UpdateUserBody extends Equatable {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'user_role', toJson: _userRoleToJson)
  final UserRole userRole;
  @JsonKey(name: 'password')
  final String? password;

  UpdateUserBody({
    required this.name,
    required this.userRole,
    required this.password,
  });

  factory UpdateUserBody.fromJson(Map<String, dynamic> json) => _$UpdateUserBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserBodyToJson(this);

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
        userRole,
        password,
      ];

  @override
  String toString() {
    return 'UpdateUserBody{name: $name, userRole: $userRole, password: $password}';
  }
}
