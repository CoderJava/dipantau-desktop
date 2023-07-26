import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/sync_manual/sync_manual_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('RunSyncManualEvent', () {
    final tBody = BulkCreateTrackDataBody.fromJson(
      json.decode(
        fixture('bulk_create_track_data_body.json'),
      ),
    );
    final tEvent = RunSyncManualEvent(body: tBody);

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'RunSyncManualEvent{body: ${tEvent.body}}',
        );
      },
    );
  });
}