import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/verify_email/verify_email_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  final tModel = VerifyEmailBody.fromJson(
    json.decode(
      fixture('verify_email_body.json'),
    ),
  );

  test(
    'pastikan output dari fungsi toString',
    () async {
      // assert
      expect(
        tModel.toString(),
        'VerifyEmailBody{code: ${tModel.code}}',
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
          tModel.code,
        ],
      );
    },
  );

  test(
    'pastikan output dari fungsi fromJson',
    () async {
      // arrange
      final jsonData = json.decode(fixture('verify_email_body.json'));

      // act
      final actualModel = VerifyEmailBody.fromJson(jsonData);

      // assert
      expect(actualModel, tModel);
    },
  );

  test(
    'pastikan output dari fungsi toJson',
    () async {
      // arrange
      final model = VerifyEmailBody.fromJson(
        json.decode(
          fixture('verify_email_body.json'),
        ),
      );

      // act
      final actualMap = json.encode(model.toJson());

      // assert
      expect(actualMap, json.encode(model.toJson()));
    },
  );
}
