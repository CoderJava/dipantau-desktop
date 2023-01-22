import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/general/general_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
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
}
