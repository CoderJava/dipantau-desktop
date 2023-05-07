import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_profile/get_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late GetProfile useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetProfile(
      repository: mockRepository,
    );
  });

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tParams = NoParams();
      final tResponse = UserProfileResponse.fromJson(
        json.decode(
          fixture('user_profile_super_admin_response.json'),
        ),
      );
      when(mockRepository.getProfile()).thenAnswer((_) async => Right(tResponse));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Right(tResponse));
      verify(mockRepository.getProfile());
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
