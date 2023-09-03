import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/manual_create_track/manual_create_track_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/manual_tracking/manual_tracking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('CreateManualTrackingEvent', () {
    final body = ManualCreateTrackBody.fromJson(
      json.decode(
        fixture('manual_create_track_body.json'),
      ),
    );
    final event = CreateManualTrackingEvent(body: body);

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          event.toString(),
          'CreateManualTrackingEvent{body: $body}',
        );
      },
    );
  });

  group('LoadDataProjectTaskManualTrackingEvent', () {
    final event = LoadDataProjectTaskManualTrackingEvent(userId: 'userId');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          event.toString(),
          'LoadDataProjectTaskManualTrackingEvent{userId: ${event.userId}}',
        );
      },
    );
  });
}
