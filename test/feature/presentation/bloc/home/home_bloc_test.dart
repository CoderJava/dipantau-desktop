import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user_lite/get_track_user_lite.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/home/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late HomeBloc bloc;
  late MockGetTrackUserLite mockGetTrackUserLite;

  setUp(() {
    mockGetTrackUserLite = MockGetTrackUserLite();
    bloc = HomeBloc(
      getTrackUserLite: mockGetTrackUserLite,
    );
  });

  const errorMessage = 'testErrorMessage';
  final connectionError = ConstantErrorMessage().connectionError;
  final parsingError = ConstantErrorMessage().parsingError;

  test(
    'pastikan output dari initialState',
    () async {
      // assert
      expect(
        bloc.state,
        InitialHomeState(),
      );
    },
  );

  group('load data', () {
    const tDate = 'testDate';
    const tProjectId = 'testProjectId';
    final tParams = ParamsGetTrackUserLite(
      date: tDate,
      projectId: tProjectId,
    );
    final tEvent = LoadDataHomeEvent(date: tDate, projectId: tProjectId);
    final tResponse = TrackUserLiteResponse.fromJson(
      json.decode(
        fixture('track_user_lite_response.json'),
      ),
    );

    blocTest(
      'pastikan emit [LoadingHomeState, SuccessLoadDataHomeState] ketika terima event '
      'LoadDataHomeEvent dengan proses berhasil',
      build: () {
        when(mockGetTrackUserLite(any)).thenAnswer((_) async => Right(tResponse));
        return bloc;
      },
      act: (HomeBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingHomeState(),
        SuccessLoadDataHomeState(trackUserLiteResponse: tResponse),
      ],
      verify: (_) {
        verify(mockGetTrackUserLite(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingHomeState, FailureHomeState] ketika terima event '
      'LoadDataHomeEvent dengan proses gagal dari endpoint',
      build: () {
        when(mockGetTrackUserLite(any)).thenAnswer((_) async => Left(ServerFailure(errorMessage)));
        return bloc;
      },
      act: (HomeBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingHomeState(),
        FailureHomeState(errorMessage: errorMessage),
      ],
      verify: (_) {
        verify(mockGetTrackUserLite(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingHomeState, FailureHomeState] ketika terima event '
      'LoadDataHomeEvent dengan kondisi internet tidak terhubung ketika hit endpoint',
      build: () {
        when(mockGetTrackUserLite(any)).thenAnswer((_) async => Left(ConnectionFailure()));
        return bloc;
      },
      act: (HomeBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingHomeState(),
        FailureHomeState(errorMessage: connectionError),
      ],
      verify: (_) {
        verify(mockGetTrackUserLite(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingHomeState, FailureHomeState] ketika terima event '
      'LoadDataHomeEvent dengan proses gagal parsing respon dari endpoint',
      build: () {
        when(mockGetTrackUserLite(any)).thenAnswer((_) async => Left(ParsingFailure(errorMessage)));
        return bloc;
      },
      act: (HomeBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingHomeState(),
        FailureHomeState(errorMessage: parsingError),
      ],
      verify: (_) {
        verify(mockGetTrackUserLite(tParams));
      },
    );
  });
}
