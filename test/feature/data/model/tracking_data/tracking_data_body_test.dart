import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/tracking_data/tracking_data_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJson = 'tracking_data_body.json';
  final tModel = TrackingDataBody.fromJson(
    json.decode(
      fixture(tPathJson),
    ),
  );

  test(
    'pastikan output dari nilai props',
    () async {
      // assert
      expect(
        tModel.props,
        [
          tModel.email,
          tModel.formattedStartTime,
          tModel.formattedEndTime,
          tModel.durationActivityInSeconds,
          tModel.intervalInSeconds,
          tModel.percentActivity,
          tModel.screenshots,
        ],
      );
    },
  );

  test(
    'pastikan output dari fungsi toString',
    () async {
      // assert
      expect(
        tModel.toString(),
        'TrackingDataBody{email: ${tModel.email}, formattedStartTime: ${tModel.formattedStartTime}, '
        'formattedEndTime: ${tModel.formattedEndTime}, durationActivityInSeconds: ${tModel.durationActivityInSeconds}, '
        'intervalInSeconds: ${tModel.intervalInSeconds}, percentActivity: ${tModel.percentActivity}, '
        'screenshots: ${tModel.screenshots}}',
      );
    },
  );

  test(
    'pastikan fungsi fromJson bisa mengembalikan objek class model',
    () async {
      // arrange
      final jsonData = json.decode(fixture(tPathJson));

      // act
      final actualModel = TrackingDataBody.fromJson(jsonData);

      // assert
      expect(actualModel, tModel);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
    () async {
      // arrange
      final model = TrackingDataBody.fromJson(
        json.decode(
          fixture(tPathJson),
        ),
      );

      // act
      final actualMap = json.encode(model.toJson());

      // assert
      expect(actualMap, json.encode(tModel.toJson()));
    },
  );
}
