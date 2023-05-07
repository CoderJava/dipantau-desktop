import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJson = 'sign_up_body.json';
  final tModel = SignUpBody.fromJson(
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
          tModel.name,
          tModel.email,
          tModel.password,
          tModel.userRole,
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
        'SignUpBody{name: ${tModel.name}, email: ${tModel.email}, password: ${tModel.password}, '
        'userRole: ${tModel.userRole}}',
      );
    },
  );

  test(
    'pastikan fungsi fromJson bisa mengembalikan objek class model',
    () async {
      // arrange
      final jsonData = json.decode(fixture(tPathJson));

      // act
      final actualModel = SignUpBody.fromJson(jsonData);

      // assert
      expect(actualModel, tModel);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
    () async {
      // arrange
      final model = SignUpBody.fromJson(
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
