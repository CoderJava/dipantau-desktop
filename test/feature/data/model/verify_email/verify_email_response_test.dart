import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/verify_email/verify_email_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const pathJson = 'verify_email_response.json';
  final tModel = VerifyEmailResponse.fromJson(
    json.decode(
      fixture(pathJson),
    ),
  );

  test(
    'pastikan output dari fungsi toString',
        () async {
      // assert
      expect(
        tModel.toString(),
        'VerifyEmailResponse{message: ${tModel.message}, isAutoApproval: ${tModel.isAutoApproval}}',
      );
    },
  );

  test(
    'pastikan output dari fungsi props',
        () async {
      // assert
      expect(
        tModel.props,
        [
          tModel.message,
          tModel.isAutoApproval,
        ],
      );
    },
  );

  test(
    'pastikan output dari fungsi fromJson',
        () async {
      // arrange
      final jsonData = json.decode(fixture(pathJson));

      // act
      final actualModel = VerifyEmailResponse.fromJson(jsonData);

      // assert
      expect(actualModel, tModel);
    },
  );

  test(
    'pastikan output dari fungsi toJson',
        () async {
      // arrange
      final model = VerifyEmailResponse.fromJson(
        json.decode(
          fixture(pathJson),
        ),
      );

      // act
      final actualMap = json.encode(model.toJson());

      // assert
      expect(actualMap, json.encode(model.toJson()));
    },
  );
}
