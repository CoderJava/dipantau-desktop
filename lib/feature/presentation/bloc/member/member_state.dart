part of 'member_bloc.dart';

abstract class MemberState {}

class InitialMemberState extends MemberState {}

class LoadingCenterMemberState extends MemberState {}

class LoadingCenterOverlayMemberState extends MemberState {}

class FailureMemberState extends MemberState {
  final String errorMessage;

  FailureMemberState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureMemberState{errorMessage: $errorMessage}';
  }
}

class SuccessLoadListMemberState extends MemberState {
  final ListUserProfileResponse response;

  SuccessLoadListMemberState({required this.response});

  @override
  String toString() {
    return 'SuccessLoadListMemberState{response: $response}';
  }
}

class SuccessEditMemberState extends MemberState {}
