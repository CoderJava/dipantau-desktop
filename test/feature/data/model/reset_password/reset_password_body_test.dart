import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/reset_password/reset_password_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJson = 'reset_password_body.json';
  final tModel = ResetPasswordBody.fromJson(
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
          tModel.code,
          tModel.password,
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
        'ResetPasswordBody{code: ${tModel.code}, password: ${tModel.password}}',
      );
    },
  );

  test(
    'pastikan fungsi fromJson bisa mengembalikan objek class model',
        () async {
      // arrange
      final jsonData = json.decode(fixture(tPathJson));

      // act
      final actualModel = ResetPasswordBody.fromJson(jsonData);

      // assert
      expect(actualModel, tModel);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
        () async {
      // arrange
      final model = ResetPasswordBody.fromJson(
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
