import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_setting_response.g.dart';

@JsonSerializable()
class UserSettingResponse extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'is_enable_blur_screenshot')
  final bool? isEnableBlurScreenshot;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'name')
  final String? name;

  UserSettingResponse({
    required this.id,
    required this.isEnableBlurScreenshot,
    required this.userId,
    required this.name,
  });

  factory UserSettingResponse.fromJson(Map<String, dynamic> json) => _$UserSettingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingResponseToJson(this);

  @override
  List<Object?> get props => [
        id,
        isEnableBlurScreenshot,
        userId,
        name,
      ];

  @override
  String toString() {
    return 'UserSettingResponse{id: $id, isEnableBlurScreenshot: $isEnableBlurScreenshot, userId: $userId, name: $name}';
  }
}
