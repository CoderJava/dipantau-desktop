import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/verify_forgot_password/verify_forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';

class VerifyForgotPassword implements UseCaseRecords<GeneralResponse, ParamsVerifyForgotPassword> {
  final AuthRepository repository;

  VerifyForgotPassword({required this.repository});

  @override
  Future<({Failure? failure, GeneralResponse? response})> call(ParamsVerifyForgotPassword params) {
    return repository.verifyForgotPassword(params.body);
  }
}

class ParamsVerifyForgotPassword extends Equatable {
  final VerifyForgotPasswordBody body;

  ParamsVerifyForgotPassword({required this.body});

  @override
  List<Object?> get props => [
    body,
  ];

  @override
  String toString() {
    return 'ParamsVerifyForgotPassword{body: $body}';
  }
}