import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJson = 'create_track_body.json';
  final tModel = CreateTrackBody.fromJson(
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
          tModel.userId,
          tModel.taskId,
          tModel.startDate,
          tModel.finishDate,
          tModel.activity,
          tModel.duration,
          tModel.files,
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
        'CreateTrackBody{userId: ${tModel.userId}, taskId: ${tModel.taskId}, startDate: ${tModel.startDate}, '
        'finishDate: ${tModel.finishDate}, activity: ${tModel.activity}, duration: ${tModel.duration}, files: ${tModel.files}}',
      );
    },
  );

  test(
    'pastikan fungsi fromJson bisa mengembalikan objek class model',
    () async {
      // arrange
      final jsonData = json.decode(fixture(tPathJson));

      // act
      final actualModel = CreateTrackBody.fromJson(jsonData);

      // assert
      expect(actualModel, tModel);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
    () async {
      // arrange
      final model = CreateTrackBody.fromJson(
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
