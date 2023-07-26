import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/tracking/tracking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('CreateTimeTrackingEvent', () {
    final tBody = CreateTrackBody.fromJson(
      json.decode(
        fixture('create_track_body.json'),
      ),
    );
    final tEvent = CreateTimeTrackingEvent(body: tBody, trackEntityId: 0);

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'CreateTimeTrackingEvent{body: ${tEvent.body}, trackEntityId: ${tEvent.trackEntityId}}',
        );
      },
    );
  });
}
