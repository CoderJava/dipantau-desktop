import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJson = 'sign_up_body.json';
  const tPathJson2 = 'sign_up_body_admin.json';
  const tPathJson3 = 'sign_up_body_employee.json';
  final tModel = SignUpBody.fromJson(
    json.decode(
      fixture(tPathJson),
    ),
  );
  final tModel2 = SignUpBody.fromJson(
    json.decode(
      fixture(tPathJson2),
    ),
  );
  final tModel3 = SignUpBody.fromJson(
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
      final jsonData2 = json.decode(fixture(tPathJson2));
      final jsonData3 = json.decode(fixture(tPathJson3));

      // act
      final actualModel = SignUpBody.fromJson(jsonData);
      final actualModel2 = SignUpBody.fromJson(jsonData2);
      final actualModel3 = SignUpBody.fromJson(jsonData3);

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
      final model = SignUpBody.fromJson(
        json.decode(
          fixture(tPathJson),
        ),
      );
      final model2 = SignUpBody.fromJson(
        json.decode(
          fixture(tPathJson2),
        ),
      );
      final model3 = SignUpBody.fromJson(
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
