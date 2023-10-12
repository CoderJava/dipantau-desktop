import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kv_setting_body.g.dart';

@JsonSerializable()
class KvSettingBody extends Equatable {
  @JsonKey(name: 'discord_channel_id')
  final String? discordChannelId;
  @JsonKey(name: 'sign_up_method')
  final String? signUpMethod;

  KvSettingBody({
    required this.discordChannelId,
    required this.signUpMethod,
  });

  factory KvSettingBody.fromJson(Map<String, dynamic> json) => _$KvSettingBodyFromJson(json);

  Map<String, dynamic> toJson() => _$KvSettingBodyToJson(this);

  @override
  List<Object?> get props => [
        discordChannelId,
        signUpMethod,
      ];

  @override
  String toString() {
    return 'KvSettingBody{discordChannelId: $discordChannelId, signUpMethod: $signUpMethod}';
  }
}
