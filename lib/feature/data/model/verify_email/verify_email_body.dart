import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_email_body.g.dart';

@JsonSerializable()
class VerifyEmailBody extends Equatable {
  @JsonKey(name: 'code')
  final String code;

  VerifyEmailBody({required this.code});

  factory VerifyEmailBody.fromJson(Map<String, dynamic> json) => _$VerifyEmailBodyFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyEmailBodyToJson(this);

  @override
  List<Object?> get props => [
        code,
      ];

  @override
  String toString() {
    return 'VerifyEmailBody{code: $code}';
  }
}
