part of 'user_profile_bloc.dart';

abstract class UserProfileState {}

class InitialUserProfileState extends UserProfileState {}

class LoadingCenterUserProfileState extends UserProfileState {}

class LoadingButtonUserProfileState extends UserProfileState {}

class FailureUserProfileState extends UserProfileState {
  final String errorMessage;

  FailureUserProfileState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureUserProfileState{errorMessage: $errorMessage}';
  }
}

class FailureSnackBarUserProfileState extends UserProfileState {
  final String errorMessage;

  FailureSnackBarUserProfileState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureSnackBarUserProfileState{errorMessage: $errorMessage}';
  }
}

class SuccessLoadDataUserProfileState extends UserProfileState {
  final UserProfileResponse response;

  SuccessLoadDataUserProfileState({required this.response});

  @override
  String toString() {
    return 'SuccessLoadDataUserProfileState{response: $response}';
  }
}

class SuccessUpdateDataUserProfileState extends UserProfileState {
  final UpdateUserBody body;

  SuccessUpdateDataUserProfileState({required this.body});

  @override
  String toString() {
    return 'SuccessUpdateDataUserProfileState{body: $body}';
  }
}
