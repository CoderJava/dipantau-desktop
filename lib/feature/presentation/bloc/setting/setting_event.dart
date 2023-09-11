part of 'setting_bloc.dart';

abstract class SettingEvent {}

class LoadKvSettingEvent extends SettingEvent {}

class UpdateKvSettingEvent extends SettingEvent {
  final KvSettingBody body;

  UpdateKvSettingEvent({required this.body});

  @override
  String toString() {
    return 'UpdateKvSettingEvent{body: $body}';
  }
}

class LoadUserSettingEvent extends SettingEvent {}

class LoadAllUserSettingEvent extends SettingEvent {}

class UpdateUserSettingEvent extends SettingEvent {
  final UserSettingBody body;

  UpdateUserSettingEvent({
    required this.body,
  });

  @override
  String toString() {
    return 'UpdateUserSettingEvent{body: $body}';
  }
}
