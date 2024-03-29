import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/base_url_config.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/all_user_setting/all_user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_response.dart';

abstract class SettingRemoteDataSource {
  /// Panggil endpoint [host]/setting/key-value
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathGetKvSetting;

  Future<KvSettingResponse> getKvSetting();

  /// Panggil endpoint [host]/setting/key-value
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathSetKvSetting;

  Future<bool> setKvSetting(KvSettingBody body);

  /// Panggil endpoint [host]/setting/user/all
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathGetAllUserSetting;

  Future<AllUserSettingResponse> getAllUserSetting();

  /// Panggil endpoint [host]/setting/user
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathGetUserSetting;

  Future<UserSettingResponse> getUserSetting();

  /// Panggil endpoint [host]/setting/user
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathUpdateUserSetting;

  Future<bool> updateUserSetting(UserSettingBody body);
}

class SettingRemoteDataSourceImpl implements SettingRemoteDataSource {
  final Dio dio;

  SettingRemoteDataSourceImpl({
    required this.dio,
  });

  final baseUrl = FlavorConfig.instance.values.baseUrlSetting;
  final baseUrlConfig = BaseUrlConfig();

  @override
  String pathGetKvSetting = '';

  @override
  Future<KvSettingResponse> getKvSetting() async {
    pathGetKvSetting = '$baseUrl/key-value';
    final response = await dio.get(
      pathGetKvSetting,
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return KvSettingResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathGetKvSetting));
    }
  }

  @override
  String pathSetKvSetting = '';

  @override
  Future<bool> setKvSetting(KvSettingBody body) async {
    pathSetKvSetting = '$baseUrl/key-value';
    final response = await dio.post(
      pathSetKvSetting,
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
      throw DioException(requestOptions: RequestOptions(path: pathSetKvSetting));
    }
  }

  @override
  String pathGetAllUserSetting = '';

  @override
  Future<AllUserSettingResponse> getAllUserSetting() async {
    pathGetAllUserSetting = '$baseUrl/user/all';
    final response = await dio.get(
      pathGetAllUserSetting,
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return AllUserSettingResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathGetAllUserSetting));
    }
  }

  @override
  String pathGetUserSetting = '';

  @override
  Future<UserSettingResponse> getUserSetting() async {
    pathGetUserSetting = '$baseUrl/user';
    final response = await dio.get(
      pathGetUserSetting,
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return UserSettingResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathGetUserSetting));
    }
  }

  @override
  String pathUpdateUserSetting = '';

  @override
  Future<bool> updateUserSetting(UserSettingBody body) async {
    pathUpdateUserSetting = '$baseUrl/user';
    Map<String, dynamic>? data;
    if (body.isOverrideBlurScreenshot == null) {
      data = {
        'data': body.data,
      };
    } else {
      data = body.toJson();
    }
    final response = await dio.post(
      pathUpdateUserSetting,
      data: data,
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return true;
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathUpdateUserSetting));
    }
  }
}
