import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_approval/user_sign_up_approval_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJson = 'user_sign_up_approval_body.json';
  const tPathJson2 = 'user_sign_up_approval_2_body.json';
  final tModel = UserSignUpApprovalBody.fromJson(
    json.decode(
      fixture(tPathJson),
    ),
  );
  final tModel2 = UserSignUpApprovalBody.fromJson(
    json.decode(
      fixture(tPathJson2),
    ),
  );

  test(
    'pastikan output dari nilai props',
    () async {
      // assert
      expect(
        tModel.props,
        [
          tModel.action,
          tModel.id,
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
        'UserSignUpApprovalBody{action: ${tModel.action}, id: ${tModel.id}}',
      );
    },
  );

  test(
    'pastikan fungsi fromJson bisa mengembalikan objek class model',
    () async {
      // arrange
      final jsonData = json.decode(
        fixture(tPathJson),
      );
      final jsonData2 = json.decode(
        fixture(tPathJson2),
      );

      // act
      final actualModel = UserSignUpApprovalBody.fromJson(jsonData);
      final actualModel2 = UserSignUpApprovalBody.fromJson(jsonData2);

      // assert
      expect(actualModel, tModel);
      expect(actualModel2, tModel2);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
    () async {
      // arrange
      final model = UserSignUpApprovalBody.fromJson(
        json.decode(
          fixture(tPathJson),
        ),
      );
      final model2 = UserSignUpApprovalBody.fromJson(
        json.decode(
          fixture(tPathJson2),
        ),
      );

      // act
      final actualMap = json.encode(model.toJson());
      final actualMap2 = json.encode(model2.toJson());

      // assert
      expect(actualMap, json.encode(tModel.toJson()));
      expect(actualMap2, json.encode(tModel2.toJson()));
    },
  );
}
