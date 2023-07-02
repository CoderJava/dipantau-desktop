import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJson = 'bulk_create_track_data_body.json';
  final tModel = BulkCreateTrackDataBody.fromJson(
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
          tModel.data,
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
        'BulkCreateTrackDataBody{data: ${tModel.data}}',
      );
    },
  );

  test(
    'pastikan fungsi fromJson bisa mengembalikan objek class model',
        () async {
      // arrange
      final jsonData = json.decode(fixture(tPathJson));

      // act
      final actualModel = BulkCreateTrackDataBody.fromJson(jsonData);

      // assert
      expect(actualModel, tModel);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
        () async {
      // arrange
      final model = BulkCreateTrackDataBody.fromJson(
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
