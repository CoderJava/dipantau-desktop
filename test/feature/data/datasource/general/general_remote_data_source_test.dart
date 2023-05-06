import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/general/general_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/tracking_data/tracking_data_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late GeneralRemoteDataSource generalRemoteDataSource;
  late MockDio mockDio;
  late MockHttpClientAdapter mockDioAdapter;

  const baseUrl = 'https://example.com';

  setUp(() {
    FlavorConfig(
      values: FlavorValues(
        baseUrl: baseUrl,
        baseUrlAuth: '$baseUrl/auth',
      ),
    );
    mockDio = MockDio();
    mockDioAdapter = MockHttpClientAdapter();
    mockDio.httpClientAdapter = mockDioAdapter;
    generalRemoteDataSource = GeneralRemoteDataSourceImpl(dio: mockDio);
  });

  final tRequestOptions = RequestOptions(path: '');

  group('getProject', () {
    const tPathResponse = 'project_response.json';
    const tEmail = 'testEmail';
    final tResponse = ProjectResponse.fromJson(
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
      when(mockDio.get(any)).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint getProject benar-benar terpanggil dengan method GET',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await generalRemoteDataSource.getProject(tEmail);

        // assert
        verify(mockDio.get('$baseUrl/api/projects'));
      },
    );

    test(
      'pastikan mengembalikan objek class model ProjectResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await generalRemoteDataSource.getProject(tEmail);

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
        when(mockDio.get(any)).thenAnswer((_) async => response);

        // act
        final call = generalRemoteDataSource.getProject(tEmail);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioError>()));
      },
    );
  });

  group('createTrackingData', () {
    const tPathResponse = 'general_response.json';
    final tBody = TrackingDataBody.fromJson(
      json.decode(
        fixture('tracking_data_body.json'),
      ),
    );
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
      'pastikan endpoint createTrackingData benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await generalRemoteDataSource.createTrackingData(tBody);

        // assert
        verify(mockDio.post('$baseUrl/api/tracking', data: anyNamed('data')));
      },
    );

    test(
      'pastikan mengembalikan objek class model GeneralResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await generalRemoteDataSource.createTrackingData(tBody);

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
        final call = generalRemoteDataSource.createTrackingData(tBody);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioError>()));
      },
    );
  });
}
