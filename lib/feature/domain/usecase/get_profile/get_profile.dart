import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/user/user_repository.dart';

class GetProfile implements UseCase<UserProfileResponse, NoParams> {
  final UserRepository repository;

  GetProfile({required this.repository});

  @override
  Future<Either<Failure, UserProfileResponse>> call(NoParams params) {
    return repository.getProfile();
  }
}