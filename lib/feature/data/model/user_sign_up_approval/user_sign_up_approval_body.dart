import 'package:dipantau_desktop_client/core/util/enum/action_user_sign_up_approval.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_sign_up_approval_body.g.dart';

@JsonSerializable()
class UserSignUpApprovalBody extends Equatable {
  @JsonKey(name: 'action', toJson: _actionUserSignUpApprovalToJson)
  final ActionUserSignUpApproval action;
  @JsonKey(name: 'id')
  final int id;

  UserSignUpApprovalBody({
    required this.action,
    required this.id,
  });

  factory UserSignUpApprovalBody.fromJson(Map<String, dynamic> json) => _$UserSignUpApprovalBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UserSignUpApprovalBodyToJson(this);

  static String _actionUserSignUpApprovalToJson(ActionUserSignUpApproval action) {
    return action.toValue;
  }

  @override
  List<Object?> get props => [
    action,
    id,
  ];

  @override
  String toString() {
    return 'UserSignUpApprovalBody{action: $action, id: $id}';
  }
}