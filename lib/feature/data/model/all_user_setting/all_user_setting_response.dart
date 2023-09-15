import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_response.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'all_user_setting_response.g.dart';

@JsonSerializable()
class AllUserSettingResponse extends Equatable {
  @JsonKey(name: 'data')
  final List<UserSettingResponse>? data;

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


