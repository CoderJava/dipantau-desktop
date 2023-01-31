import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project/get_project.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/home/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late HomeBloc bloc;
  late MockSharedPreferencesManager mockSharedPreferencesManager;
  late MockGetProject mockGetProject;

  setUp(() {
    mockSharedPreferencesManager = MockSharedPreferencesManager();
    mockGetProject = MockGetProject();
    bloc = HomeBloc(
      sharedPreferencesManager: mockSharedPreferencesManager,
      getProject: mockGetProject,
    );
  });

  const errorMessage = 'testErrorMessage';
  final connectionError = ConstantErrorMessage().connectionError;

  test(
    'pastikan output dari initialState',
    () async {
      // assert
      expect(
        bloc.state,
        InitialHomeState(),
      );
    },
  );

  group('load data project', () {
    const tEmail = 'testEmail';
    final tParams = ParamsGetProject(email: tEmail);
    final tResponse = ProjectResponse.fromJson(
      json.decode(
        fixture('project_response.json'),
      ),
    );
    final tEvent = LoadDataProjectHomeEvent();

    blocTest(
      'pastikan emit [LoadingHomeState, SuccessLoadDataProjectHomeState] ketika terima event '
      'LoadDataProjectHomeEvent dengan proses berhasil',
      build: () {
        when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail)).thenReturn(tEmail);
        when(mockGetProject(any)).thenAnswer((_) async => Right(tResponse));
        return bloc;
      },
      act: (HomeBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingHomeState(),
        SuccessLoadDataProjectHomeState(project: tResponse),
      ],
      verify: (_) {
        verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail));
        verify(mockGetProject(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingHomeState, FailureHomeState] ketika terima event '
      'LoadDataProjectHomeEvent dengan nilai email null atau empty string',
      build: () {
        when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail)).thenReturn(null);
        return bloc;
      },
      act: (HomeBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingHomeState(),
        FailureHomeState(errorMessage: 'Error: Invalid email. Please relogin to fix it.'),
      ],
      verify: (_) {
        verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail));
      },
    );

    blocTest(
      'pastikan emit [LoadingHomeState, FailureHomeState] ketika terima event '
      'LoadDataProjectHomeEvent dengan proses gagal dari endpoint',
      build: () {
        when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail)).thenReturn(tEmail);
        when(mockGetProject(any)).thenAnswer((_) async => Left(ServerFailure(errorMessage)));
        return bloc;
      },
      act: (HomeBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingHomeState(),
        FailureHomeState(errorMessage: errorMessage),
      ],
      verify: (_) {
        verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail));
        verify(mockGetProject(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingHomeState, FailureHomeState] ketika terima event '
      'LoadDataProjectHomeEvent dengan kondisi internet tidak terhubung',
      build: () {
        when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail)).thenReturn(tEmail);
        when(mockGetProject(any)).thenAnswer((_) async => Left(ConnectionFailure()));
        return bloc;
      },
      act: (HomeBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingHomeState(),
        FailureHomeState(errorMessage: connectionError),
      ],
      verify: (_) {
        verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail));
        verify(mockGetProject(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingHomeState, FailureHomeState] ketika terima event '
      'LoadDataProjectHomeEvent dengan proses gagal parsing respon JSON dari endpoint',
      build: () {
        when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail)).thenReturn(tEmail);
        when(mockGetProject(any)).thenAnswer((_) async => Left(ParsingFailure(errorMessage)));
        return bloc;
      },
      act: (HomeBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingHomeState(),
        FailureHomeState(errorMessage: errorMessage),
      ],
      verify: (_) {
        verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail));
        verify(mockGetProject(tParams));
      },
    );
  });
}
