import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/refresh_token/refresh_token_body.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';

class RefreshToken implements UseCase<LoginResponse, ParamsRefreshToken> {
  final AuthRepository repository;

  RefreshToken({required this.repository});

  @override
  Future<Either<Failure, LoginResponse>> call(ParamsRefreshToken params) {
    return repository.refreshToken(params.body);
  }
}

class ParamsRefreshToken extends Equatable {
  final RefreshTokenBody body;

  ParamsRefreshToken({required this.body});

  @override
  List<Object?> get props => [
    body,
  ];

  @override
  String toString() {
    return 'ParamsRefreshToken{body: $body}';
  }
}