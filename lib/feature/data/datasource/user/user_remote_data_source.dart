import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/base_url_config.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_waiting/user_sign_up_waiting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/user_version/user_version_body.dart';

abstract class UserRemoteDataSource {
  /// Panggil endpoint [host]/profile
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathGetProfile;

  Future<UserProfileResponse> getProfile();

  /// Panggil endpoint [host]/profile/all
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathGetAllMembers;

  Future<ListUserProfileResponse> getAllMembers();

  /// Panggil endpoint [host]/profile/:id
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathUpdateUser;

  Future<bool> updateUser(UpdateUserBody body, int id);

  /// Panggil endpoint [host]/version
  late String pathSendAppVersion;

  Future<bool> sendAppVersion(UserVersionBody body);

  /// Panggil endpoint [host]/signup/waiting
  late String pathGetUserSignUpWaiting;

  Future<UserSignUpWaitingResponse> getUserSignUpWaiting();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({
    required this.dio,
  });

  final baseUrl = FlavorConfig.instance.values.baseUrlUser;
  final baseUrlConfig = BaseUrlConfig();

  @override
  String pathGetProfile = '';

  @override
  Future<UserProfileResponse> getProfile() async {
    pathGetProfile = '$baseUrl/profile';
    final response = await dio.get(
      pathGetProfile,
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return UserProfileResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathGetProfile));
    }
  }

  @override
  String pathGetAllMembers = '';

  @override
  Future<ListUserProfileResponse> getAllMembers() async {
    pathGetAllMembers = '$baseUrl/profile/all';
    final response = await dio.get(
      pathGetAllMembers,
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return ListUserProfileResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathGetAllMembers));
    }
  }

  @override
  String pathUpdateUser = '';

  @override
  Future<bool> updateUser(UpdateUserBody body, int id) async {
    pathUpdateUser = '$baseUrl/profile/$id';
    final response = await dio.post(
      pathUpdateUser,
      data: body.toJson(),
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return true;
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathUpdateUser));
    }
  }

  @override
  String pathSendAppVersion = '';

  @override
  Future<bool> sendAppVersion(UserVersionBody body) async {
    pathSendAppVersion = '$baseUrl/version';
    final response = await dio.post(
      pathSendAppVersion,
      data: body.toJson(),
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return true;
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathSendAppVersion));
    }
  }

  @override
  String pathGetUserSignUpWaiting = '';

  @override
  Future<UserSignUpWaitingResponse> getUserSignUpWaiting() async {
    pathGetUserSignUpWaiting = '$baseUrl/signup/waiting';
    final response = await dio.get(
      pathGetUserSignUpWaiting,
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return UserSignUpWaitingResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathGetUserSignUpWaiting));
    }
  }
}
