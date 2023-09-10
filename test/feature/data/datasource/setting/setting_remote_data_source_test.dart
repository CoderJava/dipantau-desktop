import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/setting/setting_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/all_user_setting/all_user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late SettingRemoteDataSource remoteDataSource;
  late MockDio mockDio;
  late MockHttpClientAdapter mockDioAdapter;

  const baseUrl = 'https://example.com/setting';

  setUp(() {
    FlavorConfig(
      values: FlavorValues(
        baseUrl: '',
        baseUrlAuth: '',
        baseUrlUser: '',
        baseUrlTrack: '',
        baseUrlProject: '',
        baseUrlSetting: baseUrl,
      ),
    );
    mockDio = MockDio();
    mockDioAdapter = MockHttpClientAdapter();
    mockDio.httpClientAdapter = mockDioAdapter;
    remoteDataSource = SettingRemoteDataSourceImpl(dio: mockDio);
  });

  final tRequestOptions = RequestOptions(path: '');

  group('getKvSetting', () {
    const tPathResponse = 'kv_setting_response.json';
    final tResponse = KvSettingResponse.fromJson(
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
      'pastikan endpoint getKvSetting benar-benar terpanggil dengan method GET',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.getKvSetting();

        // assert
        verify(mockDio.get('$baseUrl/key-value', options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan objek class model KvSettingResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.getKvSetting();

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
        final call = remoteDataSource.getKvSetting();

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('setKvSetting', () {
    final tBody = KvSettingBody.fromJson(
      json.decode(
        fixture('kv_setting_body.json'),
      ),
    );
    const tPathResponse = 'general_response.json';
    const tResponse = true;

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
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint setKvSetting benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.setKvSetting(tBody);

        // assert
        verify(mockDio.post('$baseUrl/key-value', data: anyNamed('data'), options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan nilai boolean true ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.setKvSetting(tBody);

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
        final call = remoteDataSource.setKvSetting(tBody);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('getAllUserSetting', () {
    const tPathResponse = 'all_user_setting_response.json';
    final tResponse = AllUserSettingResponse.fromJson(
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
      'pastikan endpoint getAllUserSetting benar-benar terpanggil dengan method GET',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.getAllUserSetting();

        // assert
        verify(mockDio.get('$baseUrl/user/all', options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan objek class model AllUserSettingResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.getAllUserSetting();

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
        final call = remoteDataSource.getAllUserSetting();

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('getUserSetting', () {
    const tPathResponse = 'user_setting_response.json';
    final tResponse = UserSettingResponse.fromJson(
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
      'pastikan endpoint getUserSetting benar-benar terpanggil dengan method GET',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.getUserSetting();

        // assert
        verify(mockDio.get('$baseUrl/user', options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan objek class model UserSettingResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.getUserSetting();

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
        final call = remoteDataSource.getUserSetting();

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('updateUserSetting', () {
    final body = UserSettingBody.fromJson(
      json.decode(
        fixture('user_setting_body.json'),
      ),
    );
    const tPathResponse = 'general_response.json';
    const tResponse = true;

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
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint updateUserSetting benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.updateUserSetting(body);

        // assert
        verify(mockDio.post('$baseUrl/user', data: anyNamed('data'), options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan objek class model GeneralResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.updateUserSetting(body);

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
        final call = remoteDataSource.updateUserSetting(body);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });
}
