import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/track/track_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_image_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user/track_user_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late TrackRemoteDataSource remoteDataSource;
  late MockDio mockDio;
  late MockHttpClientAdapter mockDioAdapter;

  const baseUrl = 'https://example.com/track';

  setUp(() {
    FlavorConfig(
      values: FlavorValues(
        baseUrl: '',
        baseUrlAuth: '',
        baseUrlUser: '',
        baseUrlTrack: baseUrl,
        baseUrlProject: '',
      ),
    );
    mockDio = MockDio();
    mockDioAdapter = MockHttpClientAdapter();
    mockDio.httpClientAdapter = mockDioAdapter;
    remoteDataSource = TrackRemoteDataSourceImpl(dio: mockDio);
  });

  final tRequestOptions = RequestOptions(path: '');

  group('getTrackUserLite', () {
    const tDate = 'testDate';
    const tProjectId = 'testProjectId';
    const tPathResponse = 'track_user_lite_response.json';
    final tResponse = TrackUserLiteResponse.fromJson(
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
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
          .thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint getTrackUserLite benar-benar terpanggil dengan method GET',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.getTrackUserLite(tDate, tProjectId);

        // assert
        verify(mockDio.get('$baseUrl/user/lite',
            queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan objek class model TrackUserLiteResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.getTrackUserLite(tDate, tProjectId);

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
        when(mockDio.get(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
            .thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.getTrackUserLite(tDate, tProjectId);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('createTrack', () {
    const tPathBody = 'create_track_body.json';
    const tPathResponse = 'general_response.json';
    final jsonBody = json.decode(fixture(tPathBody));
    late CreateTrackBody body;
    final tResponse = GeneralResponse.fromJson(
      json.decode(
        fixture(tPathResponse),
      ),
    );

    setUp(() {
      final files = <String>[];
      jsonBody['files'].map((element) => files.add(fromFile(element).path)).toList();
      body = CreateTrackBody(
        userId: jsonBody['user_id'],
        taskId: jsonBody['task_id'],
        startDate: jsonBody['start_date'],
        finishDate: jsonBody['finish_date'],
        activity: jsonBody['activity'],
        duration: jsonBody['duration'],
        files: files,
      );
    });

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
      'pastikan endpoint createTrack benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.createTrack(body);

        // assert
        verify(mockDio.post(baseUrl, data: anyNamed('data'), options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan objek class model GeneralResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.createTrack(body);

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
        final call = remoteDataSource.createTrack(body);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('bulkCreateTrackData', () {
    final tBody = BulkCreateTrackDataBody.fromJson(
      json.decode(
        fixture('bulk_create_track_data_body.json'),
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
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint bulkCreateTrackData benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.bulkCreateTrackData(tBody);

        // assert
        verify(mockDio.post('$baseUrl/bulk/data', data: anyNamed('data'), options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan objek class model GeneralResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.bulkCreateTrackData(tBody);

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
        final call = remoteDataSource.bulkCreateTrackData(tBody);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('bulkCreateTrackImage', () {
    const tPathBody = 'bulk_create_track_image_body.json';
    final jsonBody = json.decode(fixture(tPathBody));
    late BulkCreateTrackImageBody tBody;
    const tPathResponse = 'general_response.json';
    final tResponse = GeneralResponse.fromJson(
      json.decode(
        fixture(tPathResponse),
      ),
    );

    void setUpMockDioSuccess() {
      final files = <String>[];
      jsonBody['files'].map((element) => files.add(fromFile(element).path)).toList();
      tBody = BulkCreateTrackImageBody(files: files);
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
      'pastikan endpoint bulkCreateTrackImage benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.bulkCreateTrackImage(tBody);

        // assert
        verify(mockDio.post('$baseUrl/bulk/image', data: anyNamed('data'), options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan objek class model GeneralResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.bulkCreateTrackImage(tBody);

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
        final call = remoteDataSource.bulkCreateTrackImage(tBody);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });

  group('getTrackUser', () {
    const tDate = 'testDate';
    const tUserId = 'testProjectId';
    const tPathResponse = 'track_user_response.json';
    final tResponse = TrackUserResponse.fromJson(
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
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
          .thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint getTrackUser benar-benar terpanggil dengan method GET',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.getTrackUser(tUserId, tDate);

        // assert
        verify(
            mockDio.get('$baseUrl/user', queryParameters: anyNamed('queryParameters'), options: anyNamed('options')));
      },
    );

    test(
      'pastikan mengembalikan objek class model TrackUserResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.getTrackUser(tUserId, tDate);

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
        when(mockDio.get(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
            .thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.getTrackUser(tUserId, tDate);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioException>()));
      },
    );
  });
}
