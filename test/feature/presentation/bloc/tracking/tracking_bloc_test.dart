import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/tracking_data/tracking_data_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_tracking_data/create_tracking_data.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user_lite/get_track_user_lite.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/tracking/tracking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late TrackingBloc bloc;
  late MockCreateTrackingData mockCreateTrackingData;
  late MockGetTrackUserLite mockGetTrackUserLite;

  setUp(() {
    mockCreateTrackingData = MockCreateTrackingData();
    mockGetTrackUserLite = MockGetTrackUserLite();
    bloc = TrackingBloc(
      createTrackingData: mockCreateTrackingData,
      getTrackUserLite: mockGetTrackUserLite,
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
    final tBody = TrackingDataBody.fromJson(
      json.decode(
        fixture('tracking_data_body.json'),
      ),
    );
    final tParams = ParamsCreateTrackingData(body: tBody);
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
        when(mockCreateTrackingData(any)).thenAnswer((_) async => Right(tResponse));
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
        verify(mockCreateTrackingData(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'CreateTimeTrackingEvent dengan proses gagal dari endpoint',
      build: () {
        when(mockCreateTrackingData(any)).thenAnswer((_) async => Left(ServerFailure(tErrorMessage)));
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
        verify(mockCreateTrackingData(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'CreateTimeTrackingEvent dengan kondisi internet tidak terhubung',
      build: () {
        when(mockCreateTrackingData(any)).thenAnswer((_) async => Left(ConnectionFailure()));
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
        verify(mockCreateTrackingData(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'CreateTimeTrackingEvent dengan proses gagal parsing respon JSON dari endpoint',
      build: () {
        when(mockCreateTrackingData(any)).thenAnswer((_) async => Left(ParsingFailure(tErrorMessage)));
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
        verify(mockCreateTrackingData(tParams));
      },
    );
  });

  group('load data tracking', () {
    const tDate = 'testDate';
    const tProjectId = 'testProjectId';
    final tParams = ParamsGetTrackUserLite(
      date: tDate,
      projectId: tProjectId,
    );
    final tEvent = LoadDataTrackingEvent(
      date: tDate,
      projectId: tProjectId,
    );
    final tResponse = TrackUserLiteResponse.fromJson(
      json.decode(
        fixture('track_user_lite_response.json'),
      ),
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, SuccessLoadDataTrackingState] ketika terima event '
      'LoadDataTrackingEvent dengan proses berhasil',
      build: () {
        when(mockGetTrackUserLite(any)).thenAnswer((_) async => Right(tResponse));
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingTrackingState>(),
        isA<SuccessLoadDataTrackingState>(),
      ],
      verify: (_) {
        verify(mockGetTrackUserLite(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'LoadDataTrackingEvent dengan proses berhasil gagal dari endpoint',
      build: () {
        when(mockGetTrackUserLite(any)).thenAnswer((_) async => Left(ServerFailure(tErrorMessage)));
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
        verify(mockGetTrackUserLite(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'LoadDataTrackingEvent dengan kondisi internet tidak terhubung ketika hit endpoint',
      build: () {
        when(mockGetTrackUserLite(any)).thenAnswer((_) async => Left(ConnectionFailure()));
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
        verify(mockGetTrackUserLite(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'LoadDataTrackingEvent dengan proses berhasil gagal parsing respon JSON dari endpoint',
      build: () {
        when(mockGetTrackUserLite(any)).thenAnswer((_) async => Left(ParsingFailure(tErrorMessage)));
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
        verify(mockGetTrackUserLite(tParams));
      },
    );
  });
}
