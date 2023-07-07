import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_response.g.dart';

@JsonSerializable()
class UserProfileResponse extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'user_role', fromJson: _userRoleFromJson)
  final UserRole? role;

  UserProfileResponse({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) => _$UserProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileResponseToJson(this);

  static UserRole? _userRoleFromJson(dynamic value) {
    if (value is String) {
      final strValue = value.toLowerCase();
      if (strValue == 'super_admin') {
        return UserRole.superAdmin;
      } else if (strValue == 'admin') {
        return UserRole.admin;
      } else if (strValue == 'employee') {
        return UserRole.employee;
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    role,
  ];

  @override
  String toString() {
    return 'UserProfileResponse{id: $id, name: $name, username: $username, role: $role}';
  }
}
