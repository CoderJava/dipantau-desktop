import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/project/project_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late ProjectRemoteDataSource remoteDataSource;
  late MockDio mockDio;
  late MockHttpClientAdapter mockDioAdapter;

  const baseUrl = 'https://example.com/project';

  setUp(() {
    FlavorConfig(
      values: FlavorValues(
        baseUrl: '',
        baseUrlAuth: '',
        baseUrlUser: '',
        baseUrlTrack: '',
        baseUrlProject: baseUrl,
        baseUrlSetting: '',
      ),
    );
    mockDio = MockDio();
    mockDioAdapter = MockHttpClientAdapter();
    mockDio.httpClientAdapter = mockDioAdapter;
    remoteDataSource = ProjectRemoteDataSourceImpl(dio: mockDio);
  });

  final tRequestOptions = RequestOptions(path: '');

  group('getProject', () {
    const tUserId = 'testUserId';
    const tPathResponse = 'project_response.json';
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
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint getProject benar-benar terpanggil dengan method GET',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.getProject(tUserId);

        // assert
        verify(mockDio.get('$baseUrl/user/$tUserId', options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan objek class model ProjectResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.getProject(tUserId);

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
        final call = remoteDataSource.getProject(tUserId);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });
}
