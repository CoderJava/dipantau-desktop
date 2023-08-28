import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/manual_create_track/manual_create_track_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_manual_track/create_manual_track.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/manual_tracking/manual_tracking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late ManualTrackingBloc bloc;
  late MockHelper mockHelper;
  late MockCreateManualTrack mockCreateManualTrack;

  setUp(() {
    mockHelper = MockHelper();
    mockCreateManualTrack = MockCreateManualTrack();
    bloc = ManualTrackingBloc(
      helper: mockHelper,
      createManualTrack: mockCreateManualTrack,
    );
  });

  const tErrorMessage = 'testErrorMessage';

  test(
    'pastikan output dari initial state',
    () async {
      // assert
      expect(
        bloc.state,
        isA<InitialManualTrackingState>(),
      );
    },
  );

  group('create manual tracking', () {
    final body = ManualCreateTrackBody.fromJson(
      json.decode(
        fixture('manual_create_track_body.json'),
      ),
    );
    final params = ParamsCreateManualTrack(body: body);
    final event = CreateManualTrackingEvent(body: body);

    blocTest(
      'pastikan emit [LoadingManualTrackingState, SuccessCreateManualTrackingState] ketika terima event '
      'CreateManualTrackingEvent dengan proses berhasil',
      build: () {
        final response = GeneralResponse.fromJson(
          json.decode(
            fixture('general_response.json'),
          ),
        );
        final result = (failure: null, response: response);
        when(mockCreateManualTrack(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ManualTrackingBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingManualTrackingState>(),
        isA<SuccessCreateManualTrackingState>(),
      ],
      verify: (_) {
        verify(mockCreateManualTrack(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingManualTrackingState, FailureManualTrackingState] ketika terima event '
      'CreateManualTrackingEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(tErrorMessage), response: null);
        when(mockCreateManualTrack(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ManualTrackingBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingManualTrackingState>(),
        isA<FailureManualTrackingState>(),
      ],
      verify: (_) {
        verify(mockCreateManualTrack(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingManualTrackingState, FailureManualTrackingState] ketika terima event '
      'CreateManualTrackingEvent dengan kondisi internet tidak terhubung ketika hit endpoint',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockCreateManualTrack(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ManualTrackingBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingManualTrackingState>(),
        isA<FailureManualTrackingState>(),
      ],
      verify: (_) {
        verify(mockCreateManualTrack(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingManualTrackingState, FailureManualTrackingState] ketika terima event '
      'CreateManualTrackingEvent dengan proses gagal parsing respon JSON dari endpoint',
      build: () {
        final result = (failure: ParsingFailure(tErrorMessage), response: null);
        when(mockCreateManualTrack(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ManualTrackingBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingManualTrackingState>(),
        isA<FailureManualTrackingState>(),
      ],
      verify: (_) {
        verify(mockCreateManualTrack(params));
      },
    );
  });
}
