import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJson = 'login_response.json';
  const tPathJson2 = 'login_admin_response.json';
  const tPathJson3 = 'login_employee_response.json';
  final tModel = LoginResponse.fromJson(
    json.decode(
      fixture(tPathJson),
    ),
  );
  final tModel2 = LoginResponse.fromJson(
    json.decode(
      fixture(tPathJson2),
    ),
  );
  final tModel3 = LoginResponse.fromJson(
    json.decode(
      fixture(tPathJson3),
    ),
  );

  test(
    'pastikan output dari nilai props',
    () async {
      // assert
      expect(
        tModel.props,
        [
          tModel.accessToken,
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
        'LoginResponse{accessToken: ${tModel.accessToken}, refreshToken: ${tModel.refreshToken}}',
      );
    },
  );

  test(
    'pastikan fungsi fromJson bisa mengembalikan objek class model',
    () async {
      // arrange
      final jsonData = json.decode(fixture(tPathJson));
      final jsonData2 = json.decode(fixture(tPathJson2));
      final jsonData3 = json.decode(fixture(tPathJson3));

      // act
      final actualModel = LoginResponse.fromJson(jsonData);
      final actualModel2 = LoginResponse.fromJson(jsonData2);
      final actualModel3 = LoginResponse.fromJson(jsonData3);

      // assert
      expect(actualModel, tModel);
      expect(actualModel2, tModel2);
      expect(actualModel3, tModel3);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
    () async {
      // arrange
      final model = LoginResponse.fromJson(
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
