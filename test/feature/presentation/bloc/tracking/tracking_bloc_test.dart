import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_track/create_track.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/delete_track_user/delete_track_user.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/tracking/tracking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late TrackingBloc bloc;
  late MockCreateTrack mockCreateTrack;
  late MockHelper mockHelper;
  late MockDeleteTrackUser mockDeleteTrackUser;

  setUp(() {
    mockCreateTrack = MockCreateTrack();
    mockHelper = MockHelper();
    mockDeleteTrackUser = MockDeleteTrackUser();
    bloc = TrackingBloc(
      createTrack: mockCreateTrack,
      helper: mockHelper,
      deleteTrackUser: mockDeleteTrackUser,
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
    final tEvent = CreateTimeTrackingEvent(body: tBody, trackEntityId: 1);

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

  group('delete track user', () {
    const trackId = 1;
    final params = ParamsDeleteTrackUser(trackId: trackId);
    final response = GeneralResponse.fromJson(
      json.decode(
        fixture('general_response.json'),
      ),
    );
    final event = DeleteTrackUserTrackingEvent(trackId: trackId);

    blocTest(
      'pastikan emit [LoadingTrackingState, SuccessDeleteTrackingUserTrackingState] ketika terima event '
      'DeleteTrackUserTrackingEvent dengan proses berhasil',
      build: () {
        final result = (failure: null, response: response);
        when(mockDeleteTrackUser(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(event);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        isA<LoadingTrackingState>(),
        isA<SuccessDeleteTrackUserTrackingState>(),
      ],
      verify: (_) {
        verify(mockDeleteTrackUser(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'DeleteTrackUserTrackingEvent dengan proses gagal dari API',
      build: () {
        final result = (failure: ServerFailure(tErrorMessage), response: null);
        when(mockDeleteTrackUser(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(event);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        isA<LoadingTrackingState>(),
        isA<FailureTrackingState>(),
      ],
      verify: (_) {
        verify(mockDeleteTrackUser(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'DeleteTrackUserTrackingEvent dengan kondisi internet tidak terhubung',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockDeleteTrackUser(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(event);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        isA<LoadingTrackingState>(),
        isA<FailureTrackingState>(),
      ],
      verify: (_) {
        verify(mockDeleteTrackUser(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingTrackingState, FailureTrackingState] ketika terima event '
      'DeleteTrackUserTrackingEvent dengan proses gagal parsing respon JSON dari API',
      build: () {
        final result = (failure: ParsingFailure(tErrorMessage), response: null);
        when(mockDeleteTrackUser(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (TrackingBloc bloc) {
        return bloc.add(event);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        isA<LoadingTrackingState>(),
        isA<FailureTrackingState>(),
      ],
      verify: (_) {
        verify(mockDeleteTrackUser(params));
      },
    );
  });
}
