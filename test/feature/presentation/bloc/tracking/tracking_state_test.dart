import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/tracking/tracking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('FailureTrackingState', () {
    final tState = FailureTrackingState(errorMessage: 'testErrorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'FailureTrackingState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });

  group('SuccessLoadDataTrackingState', () {
    final tTrackUserLite = TrackUserLiteResponse.fromJson(
      json.decode(
        fixture('track_user_lite_response.json'),
      ),
    );
    final tState = SuccessLoadDataTrackingState(trackUserLite: tTrackUserLite);

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'SuccessLoadDataTrackingState{trackUserLite: ${tState.trackUserLite}}',
        );
      },
    );
  });
}