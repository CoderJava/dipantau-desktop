import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/refresh_token/refresh_token_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJson = 'refresh_token_body.json';
  final tModel = RefreshTokenBody.fromJson(
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
          tModel.refreshToken,
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
        'RefreshTokenBody{refreshToken: ${tModel.refreshToken}}',
      );
    },
  );

  test(
    'pastikan fungsi fromJson bisa mengembalikan objek class model',
        () async {
      // arrange
      final jsonData = json.decode(fixture(tPathJson));

      // act
      final actualModel = RefreshTokenBody.fromJson(jsonData);

      // assert
      expect(actualModel, tModel);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
        () async {
      // arrange
      final model = RefreshTokenBody.fromJson(
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
