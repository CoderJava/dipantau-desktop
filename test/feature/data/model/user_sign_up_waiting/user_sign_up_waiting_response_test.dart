import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_waiting/user_sign_up_waiting_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJson = 'user_sign_up_waiting_response.json';
  final tModel = UserSignUpWaitingResponse.fromJson(
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
          tModel.data,
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
        'UserSignUpWaitingResponse{data: ${tModel.data}}',
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

      // act
      final actualModel = UserSignUpWaitingResponse.fromJson(jsonData);

      // assert
      expect(actualModel, tModel);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
        () async {
      // arrange
      final model = UserSignUpWaitingResponse.fromJson(
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
