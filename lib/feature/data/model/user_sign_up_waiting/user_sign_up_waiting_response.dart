import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_sign_up_waiting_response.g.dart';

@JsonSerializable()
class UserSignUpWaitingResponse extends Equatable {
  @JsonKey(name: 'data')
  final List<ItemUserSignUpWaitingResponse>? data;

  UserSignUpWaitingResponse({required this.data});

  factory UserSignUpWaitingResponse.fromJson(Map<String, dynamic> json) => _$UserSignUpWaitingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserSignUpWaitingResponseToJson(this);

  @override
  List<Object?> get props => [
        data,
      ];

  @override
  String toString() {
    return 'UserSignUpWaitingResponse{data: $data}';
  }
}

@JsonSerializable()
class ItemUserSignUpWaitingResponse extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'email')
  final String? email;

  ItemUserSignUpWaitingResponse({
    required this.id,
    required this.name,
    required this.email,
  });

  factory ItemUserSignUpWaitingResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemUserSignUpWaitingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemUserSignUpWaitingResponseToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        email,
      ];

  @override
  String toString() {
    return 'ItemUserSignUpWaitingResponse{id: $id, name: $name, email: $email}';
  }
}
