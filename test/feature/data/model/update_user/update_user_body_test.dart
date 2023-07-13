import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJson = 'update_user_body.json';
  const tPathJson2 = 'update_user_body_admin.json';
  const tPathJson3 = 'update_user_body_employee.json';
  final tModel = UpdateUserBody.fromJson(
    json.decode(
      fixture(tPathJson),
    ),
  );
  final tModel2 = UpdateUserBody.fromJson(
    json.decode(
      fixture(tPathJson2),
    ),
  );
  final tModel3 = UpdateUserBody.fromJson(
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
          tModel.name,
          tModel.userRole,
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
        'UpdateUserBody{name: ${tModel.name}, userRole: ${tModel.userRole}, password: ${tModel.password}}',
      );
    },
  );

  test(
    'pastikan fungsi fromJson bisa mengembalikan objek class model',
    () async {
      // arrange
      final jsonData = json.decode(fixture(tPathJson));

      // act
      final actualModel = UpdateUserBody.fromJson(jsonData);

      // assert
      expect(actualModel, tModel);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
    () async {
      // arrange
      final model = UpdateUserBody.fromJson(
        json.decode(
          fixture(tPathJson),
        ),
      );
      final model2 = UpdateUserBody.fromJson(
        json.decode(
          fixture(tPathJson2),
        ),
      );
      final model3 = UpdateUserBody.fromJson(
        json.decode(
          fixture(tPathJson3),
        ),
      );

      // act
      final actualMap = json.encode(model.toJson());
      final actualMap2 = json.encode(model2.toJson());
      final actualMap3 = json.encode(model3.toJson());

      // assert
      expect(actualMap, json.encode(tModel.toJson()));
      expect(actualMap2, json.encode(tModel2.toJson()));
      expect(actualMap3, json.encode(tModel3.toJson()));
    },
  );
}
