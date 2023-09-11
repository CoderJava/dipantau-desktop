part of 'setting_bloc.dart';

abstract class SettingState {}

class InitialSettingState extends SettingState {}

class LoadingCenterSettingState extends SettingState {}

class LoadingButtonSettingState extends SettingState {}

class FailureSettingState extends SettingState {
  final String errorMessage;

  FailureSettingState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureSettingState{errorMessage: $errorMessage}';
  }
}

class FailureSnackBarSettingState extends SettingState {
  final String errorMessage;

  FailureSnackBarSettingState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureSnackBarSettingState{errorMessage: $errorMessage}';
  }
}

class SuccessLoadKvSettingState extends SettingState {
  final KvSettingResponse? response;

  SuccessLoadKvSettingState({required this.response});

  @override
  String toString() {
    return 'SuccessLoadKvSettingState{response: $response}';
  }
}

class SuccessUpdateKvSettingState extends SettingState {}

class SuccessLoadUserSettingState extends SettingState {
  final UserSettingResponse response;

  SuccessLoadUserSettingState({
    required this.response,
  });

  @override
  String toString() {
    return 'SuccessLoadUserSettingState{response: $response}';
  }
}

class SuccessLoadAllUserSettingState extends SettingState {
  final AllUserSettingResponse response;

  SuccessLoadAllUserSettingState({
    required this.response,
  });

  @override
  String toString() {
    return 'SuccessLoadAllUserSettingState{response: $response}';
  }
}

class SuccessUpdateUserSettingState extends SettingState {}
