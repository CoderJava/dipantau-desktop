import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_setting_body.g.dart';

@JsonSerializable()
class UserSettingBody extends Equatable {
  @JsonKey(name: 'data')
  final List<ItemUserSettingBody> data;

  UserSettingBody({
    required this.data,
  });

  factory UserSettingBody.fromJson(Map<String, dynamic> json) => _$UserSettingBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingBodyToJson(this);

  @override
  List<Object?> get props => [
        data,
      ];

  @override
  String toString() {
    return 'UserSettingBody{data: $data}';
  }
}

@JsonSerializable()
class ItemUserSettingBody extends Equatable {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'is_enable_blur_screenshot')
  final bool isEnableBlurScreenshot;
  @JsonKey(name: 'user_id')
  final int userId;

  ItemUserSettingBody({
    required this.id,
    required this.isEnableBlurScreenshot,
    required this.userId,
  });

  factory ItemUserSettingBody.fromJson(Map<String, dynamic> json) => _$ItemUserSettingBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ItemUserSettingBodyToJson(this);

  @override
  List<Object?> get props => [
        id,
        isEnableBlurScreenshot,
        userId,
      ];

  @override
  String toString() {
    return 'ItemUserSettingBody{id: $id, isEnableBlurScreenshot: $isEnableBlurScreenshot, userId: $userId}';
  }
}
