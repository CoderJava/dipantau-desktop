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
