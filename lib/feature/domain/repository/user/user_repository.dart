import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';

abstract class UserRepository {
  Future<Either<Failure, UserProfileResponse>> getProfile();

  Future<({Failure? failure, ListUserProfileResponse? response})> getAllMembers();
}