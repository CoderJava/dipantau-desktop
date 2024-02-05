import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_email_response.g.dart';

@JsonSerializable()
class VerifyEmailResponse extends Equatable {
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'is_auto_approval')
  final bool? isAutoApproval;

  VerifyEmailResponse({
    required this.message,
    required this.isAutoApproval,
  });

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) => _$VerifyEmailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyEmailResponseToJson(this);

  @override
  List<Object?> get props => [
    message,
    isAutoApproval,
  ];

  @override
  String toString() {
    return 'VerifyEmailResponse{message: $message, isAutoApproval: $isAutoApproval}';
  }
}
