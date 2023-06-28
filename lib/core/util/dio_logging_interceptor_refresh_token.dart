import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/base_url_config.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/refresh_token/refresh_token_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/refresh_token/refresh_token.dart';
import 'package:dipantau_desktop_client/injection_container.dart';
import 'package:flutter/material.dart';

class DioLoggingInterceptorRefreshToken extends InterceptorsWrapper {
  final SharedPreferencesManager sharedPreferencesManager;

  DioLoggingInterceptorRefreshToken({
    required this.sharedPreferencesManager,
  });

  final baseUrlConfig = BaseUrlConfig();
  var isRefreshTokenProcessing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.headers.containsKey(baseUrlConfig.requiredToken)) {
      final accessToken = sharedPreferencesManager.getString(SharedPreferencesManager.keyAccessToken) ?? '';
      options.headers.remove(baseUrlConfig.requiredToken);
      options.headers.addAll({'Authorization': 'Bearer $accessToken'});
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final responseCode = err.response?.statusCode;
    final message = err.message;
    final errMessage = err.error;
    debugPrint('response code: $responseCode');
    debugPrint('message: $message');
    debugPrint('errMessage: $errMessage');
    final accessToken = sharedPreferencesManager.getString(SharedPreferencesManager.keyAccessToken) ?? '';

    if (accessToken.isEmpty) {
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: Response(
            requestOptions: err.requestOptions,
            statusCode: 401,
            statusMessage: 'Http status error [401]',
            data: {
              'title': 'Error',
              'message': 'Expired token',
            },
          ),
          type: err.type,
        ),
      );
    }

    if (responseCode == 401 || responseCode == null) {
      final strRefreshToken = sharedPreferencesManager.getString(SharedPreferencesManager.keyRefreshToken) ?? '';
      if (strRefreshToken.isEmpty) {
        return handler.next(err);
      }

      isRefreshTokenProcessing = true;
      final refreshTokenBody = RefreshTokenBody(
        refreshToken: strRefreshToken,
      );
      final refreshToken = sl<RefreshToken>();
      final resultRefreshToken = await refreshToken(ParamsRefreshToken(body: refreshTokenBody));
      final resultFoldRefreshToken = resultRefreshToken.fold(
        (failure) => failure,
        (response) => response,
      );
      if (resultFoldRefreshToken is LoginResponse) {
        final newAccessToken = resultFoldRefreshToken.accessToken!;
        final newRefreshToken = resultFoldRefreshToken.refreshToken!;
        await sharedPreferencesManager.putString(SharedPreferencesManager.keyAccessToken, newAccessToken);
        await sharedPreferencesManager.putString(SharedPreferencesManager.keyRefreshToken, newRefreshToken);
        isRefreshTokenProcessing = false;
        final options = err.requestOptions;
        options.headers.remove(baseUrlConfig.requiredToken);
        options.headers.addAll({'Authorization': 'Bearer $newAccessToken'});
        final data = options.data;
        if (data is FormData) {
          var baseFilePathScreenshot =
              sharedPreferencesManager.getString(SharedPreferencesManager.keyBaseFilePathScreenshot) ?? '';
          if (baseFilePathScreenshot.isEmpty) {
            return handler.reject(err);
          }
          if (baseFilePathScreenshot.endsWith('/')) {
            baseFilePathScreenshot = baseFilePathScreenshot.substring(0, baseFilePathScreenshot.length - 1);
          }

          final formData = FormData();
          formData.fields.addAll(data.fields);

          // ini solusinya https://github.com/cfug/dio/issues/482#issuecomment-1463310856
          for (final mapFile in data.files) {
            final value = mapFile.value;
            final filename = value.filename ?? '';
            final pathFile = '$baseFilePathScreenshot/$filename';
            formData.files.add(
              MapEntry(
                mapFile.key,
                await MultipartFile.fromFile(pathFile, filename: filename),
              ),
            );
          }
          options.data = formData;
        }

        try {
          final response = await Dio().fetch(options);
          final statusCode = response.statusCode;
          if (statusCode != null && statusCode.toString().startsWith('2')) {
            return handler.resolve(response);
          }
          return handler.reject(err);
        } catch (error) {
          return handler.reject(err);
        }
      } else {
        isRefreshTokenProcessing = false;
        return handler.next(err);
      }
    }
    return handler.next(err);
  }
}
