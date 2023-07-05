import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/base_url_config.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';

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
}
