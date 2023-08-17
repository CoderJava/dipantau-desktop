import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_version_body.g.dart';

@JsonSerializable()
class UserVersionBody extends Equatable {
  @JsonKey(name: 'code')
  final String code;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'user_id')
  final int userId;

  UserVersionBody({
    required this.code,
    required this.name,
    required this.userId,
  });

  factory UserVersionBody.fromJson(Map<String, dynamic> json) => _$UserVersionBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UserVersionBodyToJson(this);

  @override
  List<Object?> get props => [
        code,
        name,
        userId,
      ];

  @override
  String toString() {
    return 'UserVersionBody{code: $code, name: $name, userId: $userId}';
  }
}
