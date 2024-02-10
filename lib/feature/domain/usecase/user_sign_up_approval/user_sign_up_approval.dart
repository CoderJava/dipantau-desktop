import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_approval/user_sign_up_approval_body.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/user/user_repository.dart';
import 'package:equatable/equatable.dart';

class UserSignUpApproval implements UseCaseRecords<GeneralResponse, ParamsUserSignUpApproval> {
  final UserRepository repository;

  UserSignUpApproval({required this.repository});

  @override
  Future<({Failure? failure, GeneralResponse? response})> call(ParamsUserSignUpApproval params) {
    return repository.userSignUpApproval(params.body);
  }
}

class ParamsUserSignUpApproval extends Equatable {
  final UserSignUpApprovalBody body;

  ParamsUserSignUpApproval({required this.body});

  @override
  List<Object?> get props => [
    body,
  ];

  @override
  String toString() {
    return 'ParamsUserSignUpApproval{body: $body}';
  }
}