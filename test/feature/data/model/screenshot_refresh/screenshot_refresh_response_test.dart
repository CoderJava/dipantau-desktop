import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const pathJson = 'screenshot_refresh_response.json';
  final tModel = ScreenshotRefreshResponse.fromJson(
    json.decode(
      fixture(pathJson),
    ),
  );

  test(
    'pastikan output dari nilai props',
    () async {
      // assert
      expect(
        tModel.props,
        [
          tModel.refreshedUrls,
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
        'ScreenshotRefreshResponse{refreshedUrls: ${tModel.refreshedUrls}}',
      );
    },
  );

  test(
    'pastikan fungsi fromJson bisa mengembalikan objek class model',
    () async {
      // arrange
      final jsonData = json.decode(fixture(pathJson));

      // act
      final actualModel = ScreenshotRefreshResponse.fromJson(jsonData);

      // assert
      expect(actualModel, tModel);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
    () async {
      // arrange
      final actualModel = ScreenshotRefreshResponse.fromJson(
        json.decode(
          fixture(pathJson),
        ),
      );

      // act
      final actualMap = json.encode(actualModel.toJson());

      // assert
      expect(actualMap, json.encode(tModel.toJson()));
    },
  );
}
