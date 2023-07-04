import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_image_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_data/bulk_create_track_data.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_image/bulk_create_track_image.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_track/create_track.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/tracking/tracking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late TrackingBloc bloc;
  late MockCreateTrack mockCreateTrack;
  late MockBulkCreateTrackData mockBulkCreateTrackData;
  late MockHelper mockHelper;
  late MockBulkCreateTrackImage mockBulkCreateTrackImage;

  setUp(() {
    mockCreateTrack = MockCreateTrack();
    mockBulkCreateTrackData = MockBulkCreateTrackData();
    mockHelper = MockHelper();
    mockBulkCreateTrackImage = MockBulkCreateTrackImage();
    bloc = TrackingBloc(
      createTrack: mockCreateTrack,
      bulkCreateTrackData: mockBulkCreateTrackData,
      helper: mockHelper,
      bulkCreateTrackImage: mockBulkCreateTrackImage,
    );
  });

  const tErrorMessage = 'testErrorMessage';

  test(
    'pastikan output dari nilai initialState',
    () async {
      // assert
      expect(
        bloc.state,
        isA<InitialTrackingState>(),
      );
    },
  );

  group('create time tracking', () {
    final tBody = CreateTrackBody.fromJson(
      json.decode(
        fixture('create_track_body.json'),
      ),
    );
    final tParams = ParamsCreateTrack(body: tBody);
    final tEvent = CreateTimeTrackingEvent(body: tBody);

    blocTest(
      'pastikan emit [LoadingTrackingState, SuccessCreateTimeTrackingState] ketika terima event '
      'CreateTimeTrackingEvent dengan proses berhasil',
      build: () {
        final tResponse = GeneralResponse.fromJson(
          json.decode(
            fixture('general_response.json'),
          ),
        );
        final result = (failure: null, response: tResponse);
        when(mockCreateTrack(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingTrackingState>(),
        isA<SuccessCreateTimeTrackingState>(),
      ],
      verify: (_) {
        verify(mockCreateTrack(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'CreateTimeTrackingEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(tErrorMessage), response: null);
        when(mockCreateTrack(any)).thenAnswer((_) async => result);
        // when(mockHelper.getErrorMessageFromFailure(result.failure));
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingTrackingState>(),
        isA<FailureTrackingState>(),
      ],
      verify: (_) {
        verify(mockCreateTrack(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'CreateTimeTrackingEvent dengan kondisi internet tidak terhubung',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockCreateTrack(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingTrackingState>(),
        isA<FailureTrackingState>(),
      ],
      verify: (_) {
        verify(mockCreateTrack(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'CreateTimeTrackingEvent dengan proses gagal parsing respon JSON dari endpoint',
      build: () {
        final result = (failure: ParsingFailure(tErrorMessage), response: null);
        when(mockCreateTrack(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingTrackingState>(),
        isA<FailureTrackingState>(),
      ],
      verify: (_) {
        verify(mockCreateTrack(tParams));
      },
    );
  });

  group('sync manual', () {
    final tBody = BulkCreateTrackDataBody.fromJson(
      json.decode(
        fixture('bulk_create_track_data_body.json'),
      ),
    );
    final tParams = ParamsBulkCreateTrackData(body: tBody);
    final tEvent = SyncManualTrackingEvent(body: tBody);

    blocTest(
      'pastikan emit [LoadingTrackingState, SuccessSyncManualTrackingState] ketika terima event '
      'SyncManualTrackingEvent dengan proses berhasil',
      build: () {
        final tResponse = GeneralResponse.fromJson(
          json.decode(
            fixture('general_response.json'),
          ),
        );
        final result = (failure: null, response: tResponse);
        when(mockBulkCreateTrackData(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingTrackingState>(),
        isA<SuccessSyncManualTrackingState>(),
      ],
      verify: (_) {
        verify(mockBulkCreateTrackData(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'SyncManualTrackingEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(tErrorMessage), response: null);
        when(mockBulkCreateTrackData(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingTrackingState>(),
        isA<FailureTrackingState>(),
      ],
      verify: (_) {
        verify(mockBulkCreateTrackData(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'SyncManualTrackingEvent dengan kondisi internet tidak terhubung',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockBulkCreateTrackData(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingTrackingState>(),
        isA<FailureTrackingState>(),
      ],
      verify: (_) {
        verify(mockBulkCreateTrackData(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'SyncManualTrackingEvent dengan proses gagal parsing respon JSON dari endpoint',
      build: () {
        final result = (failure: ParsingFailure(tErrorMessage), response: null);
        when(mockBulkCreateTrackData(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingTrackingState>(),
        isA<FailureTrackingState>(),
      ],
      verify: (_) {
        verify(mockBulkCreateTrackData(tParams));
      },
    );
  });

  group('cron tracking', () {
    final bodyData = BulkCreateTrackDataBody.fromJson(
      json.decode(
        fixture('bulk_create_track_data_body.json'),
      ),
    );
    final bodyImage = BulkCreateTrackImageBody.fromJson(
      json.decode(
        fixture('bulk_create_track_image_body.json'),
      ),
    );
    final tEvent = CronTrackingEvent(
      bodyData: bodyData,
      bodyImage: bodyImage,
    );
    final paramsData = ParamsBulkCreateTrackData(body: bodyData);
    final paramsImage = ParamsBulkCreateTrackImage(body: bodyImage);
    final tResponse = GeneralResponse.fromJson(
      json.decode(
        fixture('general_response.json'),
      ),
    );

    blocTest(
      'pastikan emit [SuccessCronTrackingState] ketika terima event CronTrackingEvent dengan proses berhasil',
      build: () {
        final result = (failure: null, response: tResponse);
        when(mockBulkCreateTrackData(any)).thenAnswer((_) async => result);
        when(mockBulkCreateTrackImage(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<SuccessCronTrackingState>(),
      ],
      verify: (_) {
        verify(mockBulkCreateTrackData(paramsData));
        verify(mockBulkCreateTrackImage(paramsImage));
      },
    );
  });
}
