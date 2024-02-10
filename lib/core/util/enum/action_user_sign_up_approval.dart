enum ActionUserSignUpApproval {
  approve,
  decline,
}

extension ActionUserSignUpApprovalExtension on ActionUserSignUpApproval {
  String get toValue {
    switch (this) {
      case ActionUserSignUpApproval.approve:
        return 'approve';
      case ActionUserSignUpApproval.decline:
        return 'decline';
    }
  }
}