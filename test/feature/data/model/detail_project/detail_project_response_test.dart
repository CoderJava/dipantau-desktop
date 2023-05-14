import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/detail_project/detail_project_response_bak.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJson = 'detail_project_response.json';
  final tModel = DetailProjectResponseBak.fromJson(
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
          tModel.id,
          tModel.name,
          tModel.trackedInSeconds,
          tModel.listTasks,
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
        'DetailProjectResponse{id: ${tModel.id}, name: ${tModel.name}, trackedInSeconds: ${tModel.trackedInSeconds}, '
        'listTasks: ${tModel.listTasks}}',
      );
    },
  );

  test(
    'pastikan fungsi fromJson bisa mengembalikan objek class model',
    () async {
      // arrange
      final jsonData = json.decode(fixture(tPathJson));

      // act
      final actualModel = DetailProjectResponseBak.fromJson(jsonData);

      // assert
      expect(actualModel, tModel);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
    () async {
      // arrange
      final model = DetailProjectResponseBak.fromJson(
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
