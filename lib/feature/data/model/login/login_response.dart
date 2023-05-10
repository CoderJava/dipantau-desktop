import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse extends Equatable {
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @JsonKey(name: 'role', fromJson: _roleFromJson)
  final UserRole? role;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  static UserRole? _roleFromJson(dynamic value) {
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
    accessToken,
    refreshToken,
    role,
  ];

  @override
  String toString() {
    return 'LoginResponse{accessToken: $accessToken, refreshToken: $refreshToken, role: $role}';
  }
}
