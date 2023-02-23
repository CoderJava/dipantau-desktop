import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'general_response.g.dart';

@JsonSerializable()
class GeneralResponse extends Equatable {
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'message')
  final String? message;

  GeneralResponse({
    required this.title,
    required this.message,
  });

  factory GeneralResponse.fromJson(Map<String, dynamic> json) => _$GeneralResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralResponseToJson(this);

  @override
  List<Object?> get props => [
    title,
    message,
  ];

  @override
  String toString() {
    return 'GeneralResponse{title: $title, message: $message}';
  }
}
