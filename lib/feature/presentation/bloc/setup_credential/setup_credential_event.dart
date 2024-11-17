part of 'setup_credential_bloc.dart';

abstract class SetupCredentialEvent {}

class PingSetupCredentialEvent extends SetupCredentialEvent {
  final String baseUrl;

  PingSetupCredentialEvent({
    required this.baseUrl,
  });

  @override
  String toString() {
    return 'PingSetupCredentialEvent{baseUrl: $baseUrl}';
  }
}
