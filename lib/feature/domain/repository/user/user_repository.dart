import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_waiting/user_sign_up_waiting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/user_version/user_version_body.dart';

abstract class UserRepository {
  Future<Either<Failure, UserProfileResponse>> getProfile();

  Future<({Failure? failure, ListUserProfileResponse? response})> getAllMembers();

  Future<({Failure? failure, bool? response})> updateUser(UpdateUserBody body, int id);

  Future<({Failure? failure, bool? response})> sendAppVersion(UserVersionBody body);

  Future<({Failure? failure, UserSignUpWaitingResponse? response})> getUserSignUpWaiting();
}
