import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/verify_email/verify_email_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/verify_email/verify_email_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';

class VerifyEmail implements UseCaseRecords<VerifyEmailResponse?, ParamsVerifyEmail> {
  final AuthRepository repository;

  VerifyEmail({required this.repository});

  @override
  Future<({Failure? failure, VerifyEmailResponse? response})> call(ParamsVerifyEmail params) async {
    return repository.verifyEmail(params.body);
  }
}

class ParamsVerifyEmail extends Equatable {
  final VerifyEmailBody body;

  ParamsVerifyEmail({required this.body});

  @override
  List<Object?> get props => [
        body,
      ];

  @override
  String toString() {
    return 'ParamsVerifyEmail{body: $body}';
  }
}
