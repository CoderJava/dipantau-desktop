import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_image_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_data/bulk_create_track_data.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_image/bulk_create_track_image.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/cron_tracking/cron_tracking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late CronTrackingBloc bloc;
  late MockHelper mockHelper;
  late MockBulkCreateTrackData mockBulkCreateTrackData;
  late MockBulkCreateTrackImage mockBulkCreateTrackImage;

  setUp(() {
    mockHelper = MockHelper();
    mockBulkCreateTrackData = MockBulkCreateTrackData();
    mockBulkCreateTrackImage = MockBulkCreateTrackImage();
    bloc = CronTrackingBloc(
      helper: mockHelper,
      bulkCreateTrackData: mockBulkCreateTrackData,
      bulkCreateTrackImage: mockBulkCreateTrackImage,
    );
  });

  test(
    'pastikan output dari initialState',
    () async {
      // assert
      expect(
        bloc.state,
        isA<InitialCronTrackingState>(),
      );
    },
  );

  group('run cron tracking', () {
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
    final tEvent = RunCronTrackingEvent(
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
      'pastikan emit [SuccessRunCronTrackingState] ketika terima event RunCronTrackingEvent dengan proses berhasil',
      build: () {
        final result = (failure: null, response: tResponse);
        when(mockBulkCreateTrackData(any)).thenAnswer((_) async => result);
        when(mockBulkCreateTrackImage(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (CronTrackingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<SuccessRunCronTrackingState>(),
      ],
      verify: (_) {
        verify(mockBulkCreateTrackData(paramsData));
        verify(mockBulkCreateTrackImage(paramsImage));
      },
    );
  });
}
