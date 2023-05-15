import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/tracking_data/tracking_data_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/tracking/tracking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('CreateTimeTrackingEvent', () {
    final tBody = TrackingDataBody.fromJson(
      json.decode(
        fixture('tracking_data_body.json'),
      ),
    );
    final tEvent = CreateTimeTrackingEvent(body: tBody);

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'CreateTimeTrackingEvent{body: ${tEvent.body}}',
        );
      },
    );
  });

  group('LoadDataTrackingEvent', () {
    final tEvent = LoadDataTrackingEvent(
      date: 'testDate',
      projectId: 'testProjectId',
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'LoadDataTrackingEvent{date: ${tEvent.date}, projectId: ${tEvent.projectId}}',
        );
      },
    );
  });
}
