import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_user_body.g.dart';

@JsonSerializable()
class UpdateUserBody extends Equatable {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'user_role')
  final UserRole userRole;

  UpdateUserBody({
    required this.name,
    required this.userRole,
  });

  factory UpdateUserBody.fromJson(Map<String, dynamic> json) => _$UpdateUserBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserBodyToJson(this);

  @override
  List<Object?> get props => [
    name,
    userRole,
  ];

  @override
  String toString() {
    return 'UpdateUserBody{name: $name, userRole: $userRole}';
  }
}
