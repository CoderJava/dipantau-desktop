import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'all_user_setting_response.g.dart';

@JsonSerializable()
class AllUserSettingResponse extends Equatable {
  @JsonKey(name: 'data')
  final List<ItemAllUserSettingResponse>? data;

  AllUserSettingResponse({required this.data});

  factory AllUserSettingResponse.fromJson(Map<String, dynamic> json) => _$AllUserSettingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllUserSettingResponseToJson(this);

  @override
  List<Object?> get props => [
        data,
      ];

  @override
  String toString() {
    return 'AllUserSettingResponse{data: $data}';
  }
}

@JsonSerializable()
class ItemAllUserSettingResponse extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'is_enable_blur_screenshot')
  final bool? isEnableBlurScreenshot;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'name')
  final String? name;

  ItemAllUserSettingResponse({
    required this.id,
    required this.isEnableBlurScreenshot,
    required this.userId,
    required this.name,
  });

  factory ItemAllUserSettingResponse.fromJson(Map<String, dynamic> json) => _$ItemAllUserSettingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemAllUserSettingResponseToJson(this);

  @override
  List<Object?> get props => [
        id,
        isEnableBlurScreenshot,
        userId,
        name,
      ];

  @override
  String toString() {
    return 'ItemAllUserSettingResponse{id: $id, isEnableBlurScreenshot: $isEnableBlurScreenshot, userId: $userId, '
        'name: $name}';
  }
}
