import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/base_url_config.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/refresh_token/refresh_token_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/refresh_token/refresh_token.dart';
import 'package:dipantau_desktop_client/injection_container.dart';

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
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final responseCode = err.response?.statusCode;
    final accessToken = sharedPreferencesManager.getString(SharedPreferencesManager.keyAccessToken) ?? '';

    if (isRefreshTokenProcessing) {
      await Future.delayed(const Duration(seconds: 2));
      final newAccessToken = sharedPreferencesManager.getString(SharedPreferencesManager.keyAccessToken) ?? '';
      final options = err.response!.requestOptions;
      options.headers.addAll({'Authorization': 'Bearer $newAccessToken'});

      try {
        final response = await Dio().fetch(options);
        final statusCode = response.statusCode;
        if (statusCode != null) {
          if (statusCode.toString().startsWith('2')) {
            return handler.resolve(response);
          }
          return handler.reject(err);
        }
        return handler.reject(err);
      } catch (_) {
        return handler.reject(err);
      }
    }

    if (accessToken.isEmpty) {
      return handler.reject(
        DioError(
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

    if (responseCode == 401) {
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
        await sharedPreferencesManager.putString(
          SharedPreferencesManager.keyUserRole,
          resultFoldRefreshToken.role?.name ?? '',
        );
        isRefreshTokenProcessing = false;
        final options = err.response!.requestOptions;
        options.headers.remove(baseUrlConfig.requiredToken);
        options.headers.addAll({'Authorization': 'Bearer $newAccessToken'});

        try {
          final response = await Dio().fetch(options);
          final statusCode = response.statusCode;
          if (statusCode != null && statusCode.toString().startsWith('2')) {
            return handler.resolve(response);
          }
          return handler.reject(err);
        } catch (_) {
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
