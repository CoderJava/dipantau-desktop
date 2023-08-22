import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/reset_password/reset_password_body.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';

class ResetPassword implements UseCaseRecords<GeneralResponse, ParamsResetPassword> {
  final AuthRepository repository;

  ResetPassword({required this.repository});

  @override
  Future<({Failure? failure, GeneralResponse? response})> call(ParamsResetPassword params) {
    return repository.resetPassword(params.body);
  }
}

class ParamsResetPassword extends Equatable {
  final ResetPasswordBody body;

  ParamsResetPassword({required this.body});

  @override
  List<Object?> get props => [
    body,
  ];

  @override
  String toString() {
    return 'ParamsResetPassword{body: $body}';
  }
}