import 'dart:convert';

import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_waiting/user_sign_up_waiting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_user_sign_up_waiting/get_user_sign_up_waiting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late GetUserSignUpWaiting useCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = GetUserSignUpWaiting(repository: mockUserRepository);
  });

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final params = NoParams();
      final response = UserSignUpWaitingResponse.fromJson(
        json.decode(
          fixture('user_sign_up_waiting_response.json'),
        ),
      );
      final tResult = (failure: null, response: response);
      when(mockUserRepository.getUserSignUpWaiting()).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(params);

      // assert
      expect(result, tResult);
      verify(mockUserRepository.getUserSignUpWaiting());
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
