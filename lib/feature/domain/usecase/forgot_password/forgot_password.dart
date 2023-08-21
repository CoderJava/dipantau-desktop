import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/forgot_password/forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';

class ForgotPassword implements UseCaseRecords<GeneralResponse, ParamsForgotPassword> {
  final AuthRepository repository;

  ForgotPassword({required this.repository});

  @override
  Future<({Failure? failure, GeneralResponse? response})> call(ParamsForgotPassword params) {
    return repository.forgotPassword(params.body);
  }
}

class ParamsForgotPassword extends Equatable {
  final ForgotPasswordBody body;

  ParamsForgotPassword({required this.body});

  @override
  List<Object?> get props => [
    body,
  ];

  @override
  String toString() {
    return 'ParamsForgotPassword{body: $body}';
  }
}