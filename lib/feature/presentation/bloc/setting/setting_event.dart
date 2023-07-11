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