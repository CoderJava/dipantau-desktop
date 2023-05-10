import 'package:equatable/equatable.dart';

class ConstantErrorMessage {
  final connectionError = 'connectionError';
  final connectionRefused = "'statusCode' was called on null";
  final connectionTimedOut = 'Connection timed out';
  final parsingError = 'parsingError';
  final failureUnknown = 'Unknown';
  final testErrorMessage = 'testErrorMessage';
}

abstract class Failure extends Equatable {}

class ServerFailure extends Failure {
  final String errorMessage;
  final Map<String, dynamic>? errorData;

  ServerFailure(
    this.errorMessage, {
    this.errorData,
  });

  @override
  List<Object?> get props => [
        errorMessage,
        errorData,
      ];

  @override
  String toString() {
    return 'ServerFailure{errorMessage: $errorMessage, errorData: $errorData}';
  }
}

class ConnectionFailure extends Failure {
  final String errorMessage = ConstantErrorMessage().connectionError;

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'ConnectionFailure{errorMessage: $errorMessage}';
  }
}

class ParsingFailure extends Failure {
  final String errorMessage;
  final String defaultErrorMessage = ConstantErrorMessage().parsingError;

  ParsingFailure(this.errorMessage);

  @override
  List<Object> get props => [
        errorMessage,
        defaultErrorMessage,
      ];

  @override
  String toString() {
    return 'ParsingFailure{errorMessage: $errorMessage, defaultErrorMessage: $defaultErrorMessage}';
  }
}
