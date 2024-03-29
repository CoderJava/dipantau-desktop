import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user/track_user_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user/get_track_user.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/report_screenshot/report_screenshot_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late ReportScreenshotBloc bloc;
  late MockHelper mockHelper;
  late MockGetTrackUser mockGetTrackUser;

  setUp(() {
    mockHelper = MockHelper();
    mockGetTrackUser = MockGetTrackUser();
    bloc = ReportScreenshotBloc(
      helper: mockHelper,
      getTrackUser: mockGetTrackUser,
    );
  });

  const tErrorMessage = 'testErrorMessage';

  test(
    'pastikan output dari initialState',
    () async {
      // assert
      expect(
        bloc.state,
        isA<InitialReportScreenshotState>(),
      );
    },
  );

  group('load report screenshot', () {
    const tUserId = 'testUserId';
    const tDate = 'testDate';
    final tParams = ParamsGetTrackUser(
      userId: tUserId,
      date: tDate,
    );
    final tEvent = LoadReportScreenshotEvent(
      userId: tUserId,
      date: tDate,
    );

    blocTest(
      'pastikan emit [LoadingCenterReportScreenshotState, SuccessLoadReportScreenshotState] ketika terima event '
      'LoadReportScreenshotEvent dengan proses berhasil',
      build: () {
        final tResponse = TrackUserResponse.fromJson(
          json.decode(
            fixture('track_user_response.json'),
          ),
        );
        final result = (failure: null, response: tResponse);
        when(mockGetTrackUser(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ReportScreenshotBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterReportScreenshotState>(),
        isA<SuccessLoadReportScreenshotState>(),
      ],
      verify: (_) {
        verify(mockGetTrackUser(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterReportScreenshotState, FailureReportScreenshotState] ketika terima event '
      'LoadReportScreenshotEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(tErrorMessage), response: null);
        when(mockGetTrackUser(any)).thenAnswer((_) async => result);
        // when(mockHelper.getErrorMessageFromFailure(result.failure));
        return bloc;
      },
      act: (ReportScreenshotBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterReportScreenshotState>(),
        isA<FailureReportScreenshotState>(),
      ],
      verify: (_) {
        verify(mockGetTrackUser(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterReportScreenshotState, FailureReportScreenshotState] ketika terima event '
      'LoadReportScreenshotEvent dengan kondisi internet tidak terhubung',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockGetTrackUser(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ReportScreenshotBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterReportScreenshotState>(),
        isA<FailureReportScreenshotState>(),
      ],
      verify: (_) {
        verify(mockGetTrackUser(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterReportScreenshotState, FailureReportScreenshotState] ketika terima event '
      'LoadReportScreenshotEvent dengan proses gagal parsing respon JSON dari endpoint',
      build: () {
        final result = (failure: ParsingFailure(tErrorMessage), response: null);
        when(mockGetTrackUser(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ReportScreenshotBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterReportScreenshotState>(),
        isA<FailureReportScreenshotState>(),
      ],
      verify: (_) {
        verify(mockGetTrackUser(tParams));
      },
    );
  });
}
