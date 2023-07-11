part of 'setting_bloc.dart';

abstract class SettingState {}

class InitialSettingState extends SettingState {}

class LoadingSettingState extends SettingState {}

class FailureSettingState extends SettingState {
  final String errorMessage;

  FailureSettingState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureSettingState{errorMessage: $errorMessage}';
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
