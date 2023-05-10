import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_body.g.dart';

@JsonSerializable()
class RefreshTokenBody extends Equatable {
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  RefreshTokenBody({
    required this.refreshToken,
  });

  factory RefreshTokenBody.fromJson(Map<String, dynamic> json) => _$RefreshTokenBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenBodyToJson(this);

  @override
  List<Object?> get props => [
        refreshToken,
      ];

  @override
  String toString() {
    return 'RefreshTokenBody{refreshToken: $refreshToken}';
  }
}
