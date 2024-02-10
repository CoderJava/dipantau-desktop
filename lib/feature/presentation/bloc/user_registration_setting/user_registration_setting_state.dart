part of 'user_registration_setting_bloc.dart';

abstract class UserRegistrationSettingState {}

class InitialUserRegistrationSettingState extends UserRegistrationSettingState {}

class LoadingCenterUserRegistrationSettingState extends UserRegistrationSettingState {}

class LoadingCenterOverlayUserRegistrationSettingState extends UserRegistrationSettingState {}

class FailureUserRegistrationSettingState extends UserRegistrationSettingState {
  final String errorMessage;

  FailureUserRegistrationSettingState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureUserRegistrationSettingState{errorMessage: $errorMessage}';
  }
}

class SuccessPrepareDataUserRegistrationSettingState extends UserRegistrationSettingState {
  final KvSettingResponse kvSettingResponse;
  final UserSignUpWaitingResponse userSignUpWaitingResponse;

  SuccessPrepareDataUserRegistrationSettingState({
    required this.kvSettingResponse,
    required this.userSignUpWaitingResponse,
  });

  @override
  String toString() {
    return 'SuccessPrepareDataUserRegistrationSettingState{kvSettingResponse: $kvSettingResponse, userSignUpWaitingResponse: $userSignUpWaitingResponse}';
  }
}
