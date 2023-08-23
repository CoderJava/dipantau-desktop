import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/forgot_password/forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/verify_forgot_password/verify_forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('SubmitForgotPasswordEvent', () {
    final body = ForgotPasswordBody.fromJson(
      json.decode(
        fixture('forgot_password_body.json'),
      ),
    );
    final event = SubmitForgotPasswordEvent(body: body);

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          event.toString(),
          'SubmitForgotPasswordEvent{body: $body}',
        );
      },
    );
  });

  group('SubmitForgotPasswordEvent', () {
    final body = VerifyForgotPasswordBody.fromJson(
      json.decode(
        fixture('verify_forgot_password_body.json'),
      ),
    );
    final event = SubmitVerifyForgotPasswordEvent(body: body);

    test(
      'pastikan output dari fungsi toString',
          () async {
        // assert
        expect(
          event.toString(),
          'SubmitVerifyForgotPasswordEvent{body: $body}',
        );
      },
    );
  });
}