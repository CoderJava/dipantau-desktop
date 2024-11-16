part of 'setup_credential_bloc.dart';

abstract class SetupCredentialState {}

class InitialSetupCredentialState extends SetupCredentialState {}

class LoadingSetupCredentialState extends SetupCredentialState {}

class FailureSetupCredentialState extends SetupCredentialState {
  final String errorMessage;

  FailureSetupCredentialState({
    required this.errorMessage,
  });

  @override
  String toString() {
    return 'FailureSetupCredentialState{errorMessage: $errorMessage}';
  }
}

class SuccessPingSetupCredentialState extends SetupCredentialState {}
