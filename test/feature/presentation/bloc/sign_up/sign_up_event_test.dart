import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('SubmitSignUpEvent', () {
    final tEvent = SubmitSignUpEvent(
      body: SignUpBody.fromJson(
        json.decode(
          fixture('sign_up_body.json'),
        ),
      ),
    );

    test(
      'pastikan output dari nilai props',
      () async {
        // assert
        expect(
          tEvent.props,
          [
            tEvent.body,
          ],
        );
      },
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'SubmitSignUpEvent{body: ${tEvent.body}}',
        );
      },
    );
  });
}
