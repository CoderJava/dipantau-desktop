import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/user/user_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_waiting/user_sign_up_waiting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/user_version/user_version_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late UserRemoteDataSource remoteDataSource;
  late MockDio mockDio;
  late MockHttpClientAdapter mockDioAdapter;

  const baseUrl = 'https://example.com/user';

  setUp(() {
    FlavorConfig(
      values: FlavorValues(
        baseUrl: '',
        baseUrlAuth: '',
        baseUrlUser: baseUrl,
        baseUrlTrack: '',
        baseUrlProject: '',
        baseUrlSetting: '',
      ),
    );
    mockDio = MockDio();
    mockDioAdapter = MockHttpClientAdapter();
    mockDio.httpClientAdapter = mockDioAdapter;
    remoteDataSource = UserRemoteDataSourceImpl(dio: mockDio);
  });

  final tRequestOptions = RequestOptions(path: '');

  group('getProfile', () {
    const tPathResponse = 'user_profile_super_admin_response.json';
    final tResponse = UserProfileResponse.fromJson(
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
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint getProfile benar-benar terpanggil dengan method GET',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.getProfile();

        // assert
        verify(mockDio.get('$baseUrl/profile', options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan objek class model UserProfileResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.getProfile();

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
        when(mockDio.get(any, options: anyNamed('options'))).thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.getProfile();

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('getAllMembers', () {
    const tPathResponse = 'list_user_profile_response.json';
    final tResponse = ListUserProfileResponse.fromJson(
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
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint getAllMembers benar-benar terpanggil dengan method GET',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.getAllMembers();

        // assert
        verify(mockDio.get('$baseUrl/profile/all', options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan objek class model ListUserProfileResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.getAllMembers();

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
        when(mockDio.get(any, options: anyNamed('options'))).thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.getAllMembers();

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('updateUser', () {
    const tResponse = true;
    const tId = 1;
    final tBody = UpdateUserBody.fromJson(
      json.decode(
        fixture('update_user_body.json'),
      ),
    );

    void setUpMockDioSuccess() {
      final responsePayload = json.decode(fixture('general_response.json'));
      final response = Response(
        requestOptions: tRequestOptions,
        data: responsePayload,
        statusCode: 200,
        headers: Headers.fromMap({
          Headers.contentTypeHeader: [Headers.jsonContentType],
        }),
      );
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint updateUser benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.updateUser(tBody, tId);

        // assert
        verify(mockDio.post('$baseUrl/profile/$tId', data: anyNamed('data'), options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan boolean true ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.updateUser(tBody, tId);

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
        when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.updateUser(tBody, tId);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('sendAppVersion', () {
    const tResponse = true;
    final tBody = UserVersionBody.fromJson(
      json.decode(
        fixture('user_version_body.json'),
      ),
    );

    void setUpMockDioSuccess() {
      final responsePayload = json.decode(fixture('general_response.json'));
      final response = Response(
        requestOptions: tRequestOptions,
        data: responsePayload,
        statusCode: 200,
        headers: Headers.fromMap({
          Headers.contentTypeHeader: [Headers.jsonContentType],
        }),
      );
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint sendAppVersion benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.sendAppVersion(tBody);

        // assert
        verify(mockDio.post('$baseUrl/version', data: anyNamed('data'), options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan boolean true ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.sendAppVersion(tBody);

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
        when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.sendAppVersion(tBody);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('getUserSignUpWaiting', () {
    const tPathResponse = 'user_sign_up_waiting_response.json';
    final tResponse = UserSignUpWaitingResponse.fromJson(
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
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint getUserSignUpWaiting benar-benar terpanggil dengan method GET',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.getUserSignUpWaiting();

        // assert
        verify(mockDio.get('$baseUrl/signup/waiting', options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan objek class model UserSignUpWaitingResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.getUserSignUpWaiting();

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
        when(mockDio.get(any, options: anyNamed('options'))).thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.getUserSignUpWaiting();

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });
}
