import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_data/bulk_create_track_data.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/sync_manual/sync_manual_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late SyncManualBloc bloc;
  late MockHelper mockHelper;
  late MockBulkCreateTrackData mockBulkCreateTrackData;

  setUp(() {
    mockHelper = MockHelper();
    mockBulkCreateTrackData = MockBulkCreateTrackData();
    bloc = SyncManualBloc(
      helper: mockHelper,
      bulkCreateTrackData: mockBulkCreateTrackData,
    );
  });

  const tErrorMessage = 'testErrorMessage';

  test(
    'pastikan output dari initialState',
    () async {
      // assert
      expect(
        bloc.state,
        isA<InitialSyncManualState>(),
      );
    },
  );

  group('run sync manual', () {
    final tBody = BulkCreateTrackDataBody.fromJson(
      json.decode(
        fixture('bulk_create_track_data_body.json'),
      ),
    );
    final tEvent = RunSyncManualEvent(body: tBody);
    final tParams = ParamsBulkCreateTrackData(body: tBody);

    blocTest(
      'pastikan emit [LoadingSyncManualState, SuccessRunSyncManualState] ketika terima event '
      'RunSyncManualEvent dengan proses berhasil',
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
      act: (SyncManualBloc bloc) {
        return bloc.add(tEvent);
      },
      wait: const Duration(milliseconds: 2500),
      expect: () => [
        isA<LoadingSyncManualState>(),
        isA<SuccessRunSyncManualState>(),
      ],
      verify: (_) {
        verify(mockBulkCreateTrackData(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingSyncManualState, FailureSyncManualState] ketika terima event '
      'RunSyncManualEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(tErrorMessage), response: null);
        when(mockBulkCreateTrackData(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SyncManualBloc bloc) {
        return bloc.add(tEvent);
      },
      wait: const Duration(milliseconds: 2500),
      expect: () => [
        isA<LoadingSyncManualState>(),
        isA<FailureSyncManualState>(),
      ],
      verify: (_) {
        verify(mockBulkCreateTrackData(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingSyncManualState, FailureSyncManualState] ketika terima event '
      'RunSyncManualEvent dengan kondisi gagal terhubung ke internet ketika hit endpoint',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockBulkCreateTrackData(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SyncManualBloc bloc) {
        return bloc.add(tEvent);
      },
      wait: const Duration(milliseconds: 2500),
      expect: () => [
        isA<LoadingSyncManualState>(),
        isA<FailureSyncManualState>(),
      ],
      verify: (_) {
        verify(mockBulkCreateTrackData(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingSyncManualState, FailureSyncManualState] ketika terima event '
      'RunSyncManualEvent dengan proses gagal parsing respon JSON dari endpoint',
      build: () {
        final result = (failure: ParsingFailure(tErrorMessage), response: null);
        when(mockBulkCreateTrackData(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SyncManualBloc bloc) {
        return bloc.add(tEvent);
      },
      wait: const Duration(milliseconds: 2500),
      expect: () => [
        isA<LoadingSyncManualState>(),
        isA<FailureSyncManualState>(),
      ],
      verify: (_) {
        verify(mockBulkCreateTrackData(tParams));
      },
    );
  });
}
