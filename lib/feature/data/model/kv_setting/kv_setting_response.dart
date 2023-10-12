import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kv_setting_response.g.dart';

@JsonSerializable()
class KvSettingResponse extends Equatable {
  @JsonKey(name: 'discord_channel_id')
  final String? discordChannelId;
  @JsonKey(name: 'sign_up_method')
  final String? signUpMethod;

  KvSettingResponse({
    required this.discordChannelId,
    required this.signUpMethod,
  });

  factory KvSettingResponse.fromJson(Map<String, dynamic> json) => _$KvSettingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KvSettingResponseToJson(this);

  @override
  List<Object?> get props => [
        discordChannelId,
        signUpMethod,
      ];

  @override
  String toString() {
    return 'KvSettingResponse{discordChannelId: $discordChannelId, signUpMethod: $signUpMethod}';
  }
}
