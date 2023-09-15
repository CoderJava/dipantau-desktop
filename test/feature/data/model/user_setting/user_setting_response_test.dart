import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJson = 'user_setting_response.json';
  final tModel = UserSettingResponse.fromJson(
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
          tModel.isEnableBlurScreenshot,
          tModel.userId,
          tModel.name,
          tModel.isOverrideBlurScreenshot,
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
        'UserSettingResponse{id: ${tModel.id}, isEnableBlurScreenshot: ${tModel.isEnableBlurScreenshot}, '
        'userId: ${tModel.userId}, name: ${tModel.name}, isOverrideBlurScreenshot: ${tModel.isOverrideBlurScreenshot}}',
      );
    },
  );

  test(
    'pastikan fungsi fromJson bisa mengembalikan objek class model',
    () async {
      // arrange
      final jsonData = json.decode(fixture(tPathJson));

      // act
      final actualModel = UserSettingResponse.fromJson(jsonData);

      // assert
      expect(actualModel, tModel);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
    () async {
      // arrange
      final model = UserSettingResponse.fromJson(
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
