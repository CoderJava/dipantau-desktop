import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/auth/auth_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/forgot_password/forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/refresh_token/refresh_token_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/verify_forgot_password/verify_forgot_password_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late MockDio mockDio;
  late MockHttpClientAdapter mockDioAdapter;

  const baseUrl = 'https://example.com/auth';

  setUp(() {
    FlavorConfig(
      values: FlavorValues(
        baseUrl: '',
        baseUrlAuth: baseUrl,
        baseUrlUser: '',
        baseUrlTrack: '',
        baseUrlProject: '',
        baseUrlSetting: '',
      ),
    );
    mockDio = MockDio();
    mockDioAdapter = MockHttpClientAdapter();
    mockDio.httpClientAdapter = mockDioAdapter;
    remoteDataSource = AuthRemoteDataSourceImpl(dio: mockDio);
  });

  final tRequestOptions = RequestOptions(path: '');

  group('login', () {
    const tPathBody = 'login_body.json';
    final tBody = LoginBody.fromJson(
      json.decode(
        fixture(tPathBody),
      ),
    );
    const tPathResponse = 'login_response.json';
    final tResponse = LoginResponse.fromJson(
      json.decode(
        fixture(tPathResponse),
      ),
    );

    void setUpMockDioSuccess() {
      final responsePayload = json.decode(fixture(tPathResponse));
      final response = Response(
        requestOptions: tRequestOptions,
        data: responsePayload,
        statusCode: 200,
        headers: Headers.fromMap({
          Headers.contentTypeHeader: [Headers.jsonContentType],
        }),
      );
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint login benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.login(tBody);

        // assert
        verify(mockDio.post('$baseUrl/login', data: anyNamed('data')));
      },
    );

    test(
      'pastikan mengembalikan objek class model LoginResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.login(tBody);

        // assert
        expect(result, tResponse);
      },
    );

    test(
      'pastikan akan menerima exception DioError ketika menerima respon kegagalan dari endpoint',
      () async {
        // arrange
        final response = Response(
          requestOptions: tRequestOptions,
          data: 'Bad Request',
          statusCode: 400,
        );
        when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.login(tBody);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('sign up', () {
    const tPathBody = 'sign_up_body.json';
    final tBody = SignUpBody.fromJson(
      json.decode(
        fixture(tPathBody),
      ),
    );
    final tBody2 = SignUpBody(
      name: tBody.name,
      email: tBody.email,
      password: tBody.password,
      userRole: UserRole.admin,
    );
    final tBody3 = SignUpBody(
      name: tBody.name,
      email: tBody.email,
      password: tBody.password,
      userRole: UserRole.employee,
    );
    const tPathResponse = 'sign_up_response.json';
    final tResponse = SignUpResponse.fromJson(
      json.decode(
        fixture(tPathResponse),
      ),
    );

    void setUpMockDioSuccess() {
      final responsePayload = json.decode(fixture(tPathResponse));
      final response = Response(
        requestOptions: tRequestOptions,
        data: responsePayload,
        statusCode: 200,
        headers: Headers.fromMap({
          Headers.contentTypeHeader: [Headers.jsonContentType],
        }),
      );
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint login benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.signUp(tBody);
        await remoteDataSource.signUp(tBody2);
        await remoteDataSource.signUp(tBody3);

        // assert
        verify(mockDio.post('$baseUrl/signup', data: anyNamed('data')));
      },
    );

    test(
      'pastikan mengembalikan objek class model SignUpResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.signUp(tBody);

        // assert
        expect(result, tResponse);
      },
    );

    test(
      'pastikan akan menerima exception DioException ketika menerima respon kegagalan dari endpoint',
      () async {
        // arrange
        final response = Response(
          requestOptions: tRequestOptions,
          data: 'Bad Request',
          statusCode: 400,
        );
        when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.signUp(tBody);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('refresh token', () {
    const tPathBody = 'refresh_token_body.json';
    final tBody = RefreshTokenBody.fromJson(
      json.decode(
        fixture(tPathBody),
      ),
    );
    const tPathResponse = 'login_response.json';
    final tResponse = LoginResponse.fromJson(
      json.decode(
        fixture(tPathResponse),
      ),
    );

    void setUpMockDioSuccess() {
      final responsePayload = json.decode(fixture(tPathResponse));
      final response = Response(
        requestOptions: tRequestOptions,
        data: responsePayload,
        statusCode: 200,
        headers: Headers.fromMap({
          Headers.contentTypeHeader: [Headers.jsonContentType],
        }),
      );
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint refreshToken benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.refreshToken(tBody);

        // assert
        verify(mockDio.post('$baseUrl/refresh', data: anyNamed('data')));
      },
    );

    test(
      'pastikan mengembalikan objek class model LoginResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.refreshToken(tBody);

        // assert
        expect(result, tResponse);
      },
    );

    test(
      'pastikan akan menerima exception DioException ketika menerima respon kegagalan dari endpoint',
      () async {
        // arrange
        final response = Response(
          requestOptions: tRequestOptions,
          data: 'Bad Request',
          statusCode: 400,
        );
        when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.refreshToken(tBody);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('forgot password', () {
    const tPathBody = 'forgot_password_body.json';
    final tBody = ForgotPasswordBody.fromJson(
      json.decode(
        fixture(tPathBody),
      ),
    );
    const tPathResponse = 'general_response.json';
    final tResponse = GeneralResponse.fromJson(
      json.decode(
        fixture(tPathResponse),
      ),
    );

    void setUpMockDioSuccess() {
      final responsePayload = json.decode(fixture(tPathResponse));
      final response = Response(
        requestOptions: tRequestOptions,
        data: responsePayload,
        statusCode: 200,
        headers: Headers.fromMap({
          Headers.contentTypeHeader: [Headers.jsonContentType],
        }),
      );
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint forgotPassword benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.forgotPassword(tBody);

        // assert
        verify(mockDio.post('$baseUrl/forgot-password', data: anyNamed('data')));
      },
    );

    test(
      'pastikan mengembalikan objek class model GeneralResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.forgotPassword(tBody);

        // assert
        expect(result, tResponse);
      },
    );

    test(
      'pastikan akan menerima exception DioException ketika menerima respon kegagalan dari endpoint',
      () async {
        // arrange
        final response = Response(
          requestOptions: tRequestOptions,
          data: 'Bad Request',
          statusCode: 400,
        );
        when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.forgotPassword(tBody);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('verify forgot password', () {
    const tPathBody = 'verify_forgot_password_body.json';
    final tBody = VerifyForgotPasswordBody.fromJson(
      json.decode(
        fixture(tPathBody),
      ),
    );
    const tPathResponse = 'general_response.json';
    final tResponse = GeneralResponse.fromJson(
      json.decode(
        fixture(tPathResponse),
      ),
    );

    void setUpMockDioSuccess() {
      final responsePayload = json.decode(fixture(tPathResponse));
      final response = Response(
        requestOptions: tRequestOptions,
        data: responsePayload,
        statusCode: 200,
        headers: Headers.fromMap({
          Headers.contentTypeHeader: [Headers.jsonContentType],
        }),
      );
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint verifyForgotPassword benar-benar terpanggil dengan method POST',
          () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.verifyForgotPassword(tBody);

        // assert
        verify(mockDio.post('$baseUrl/forgot-password/verify', data: anyNamed('data')));
      },
    );

    test(
      'pastikan mengembalikan objek class model GeneralResponse ketika menerima respon sukses '
          'dari endpoint',
          () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.verifyForgotPassword(tBody);

        // assert
        expect(result, tResponse);
      },
    );

    test(
      'pastikan akan menerima exception DioException ketika menerima respon kegagalan dari endpoint',
          () async {
        // arrange
        final response = Response(
          requestOptions: tRequestOptions,
          data: 'Bad Request',
          statusCode: 400,
        );
        when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.verifyForgotPassword(tBody);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });
}
