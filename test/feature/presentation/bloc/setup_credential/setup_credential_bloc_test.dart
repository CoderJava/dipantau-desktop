import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/setup_credential/setup_credential_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late SetupCredentialBloc bloc;
  late MockHelper mockHelper;
  late MockPing mockPing;

  const errorMessage = 'testErrorMessage';

  setUp(() {
    mockHelper = MockHelper();
    mockPing = MockPing();
    bloc = SetupCredentialBloc(
      helper: mockHelper,
      ping: mockPing,
    );
  });

  test(
    'pastikan output dari initial state',
    () async {
      // assert
      expect(
        bloc.state,
        isA<InitialSetupCredentialState>(),
      );
    },
  );

  group('ping setup credential', () {
    final params = NoParams();
    final event = PingSetupCredentialEvent();

    blocTest(
      'pastikan emit [LoadingSetupCredentialState, SuccessPingSetupCredentialState] ketika terima event '
      'PingSetupCredentialEvent dengan proses berhasil',
      build: () {
        final response = GeneralResponse.fromJson(
          json.decode(
            fixture('general_response.json'),
          ),
        );
        final result = (failure: null, response: response);
        when(mockPing(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SetupCredentialBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingSetupCredentialState>(),
        isA<SuccessPingSetupCredentialState>(),
      ],
      verify: (_) {
        verify(mockPing(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingSetupCredentialState, FailureSetupCredentialState] ketika terima event '
      'PingSetupCredentialEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(errorMessage), response: null);
        when(mockPing(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SetupCredentialBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingSetupCredentialState>(),
        isA<FailureSetupCredentialState>(),
      ],
      verify: (_) {
        verify(mockPing(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingSetupCredentialState, FailureSetupCredentialState] ketika terima event '
      'PingSetupCredentialEvent dengan kondisi internet tidak terhubung ketika hit endpoint',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockPing(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SetupCredentialBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingSetupCredentialState>(),
        isA<FailureSetupCredentialState>(),
      ],
      verify: (_) {
        verify(mockPing(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingSetupCredentialState, FailureSetupCredentialState] ketika terima event '
      'PingSetupCredentialEvent dengan proses gagal parsing respon JSON endpoint',
      build: () {
        final result = (failure: ParsingFailure(errorMessage), response: null);
        when(mockPing(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SetupCredentialBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingSetupCredentialState>(),
        isA<FailureSetupCredentialState>(),
      ],
      verify: (_) {
        verify(mockPing(params));
      },
    );
  });
}
