import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up_by_user/sign_up_by_user_body.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignUpByUser implements UseCaseRecords<GeneralResponse?, ParamsSignUpByUser> {
  final AuthRepository repository;

  SignUpByUser({required this.repository});

  @override
  Future<({Failure? failure, GeneralResponse? response})> call(ParamsSignUpByUser params) async {
    return repository.signUpByUser(params.body);
  }
}

class ParamsSignUpByUser extends Equatable {
  final SignUpByUserBody body;

  ParamsSignUpByUser({required this.body});

  @override
  List<Object?> get props => [
    body,
  ];

  @override
  String toString() {
    return 'ParamsSignUpByUser{body: $body}';
  }
}