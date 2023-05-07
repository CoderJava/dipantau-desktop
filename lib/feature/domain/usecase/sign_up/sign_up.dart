import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignUp implements UseCase<SignUpResponse, SignUpParams> {
  final AuthRepository repository;

  SignUp({required this.repository});

  @override
  Future<Either<Failure, SignUpResponse>> call(SignUpParams params) {
    return repository.signUp(params.body);
  }
}

class SignUpParams extends Equatable {
  final SignUpBody body;

  SignUpParams({required this.body});

  @override
  List<Object?> get props => [
    body,
  ];

  @override
  String toString() {
    return 'SignUpParams{body: $body}';
  }
}