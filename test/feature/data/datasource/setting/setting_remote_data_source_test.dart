import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/setting/setting_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
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
}
