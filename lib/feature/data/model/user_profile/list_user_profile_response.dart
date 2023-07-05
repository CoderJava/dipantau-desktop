import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_user_profile_response.g.dart';

@JsonSerializable()
class ListUserProfileResponse extends Equatable {
  @JsonKey(name: 'data')
  final List<UserProfileResponse>? data;

  ListUserProfileResponse({required this.data});

  factory ListUserProfileResponse.fromJson(Map<String, dynamic> json) => _$ListUserProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListUserProfileResponseToJson(this);

  @override
  List<Object?> get props => [
        data,
      ];

  @override
  String toString() {
    return 'ListUserProfileResponse{data: $data}';
  }
}