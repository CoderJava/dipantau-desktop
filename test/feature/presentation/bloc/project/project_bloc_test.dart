import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project/get_project.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/project/project_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late ProjectBloc bloc;
  late MockSharedPreferencesManager mockSharedPreferencesManager;
  late MockGetProject mockGetProject;

  setUp(() {
    mockSharedPreferencesManager = MockSharedPreferencesManager();
    mockGetProject = MockGetProject();
    bloc = ProjectBloc(
      sharedPreferencesManager: mockSharedPreferencesManager,
      getProject: mockGetProject,
    );
  });

  const errorMessage = 'testErrorMessage';
  final connectionError = ConstantErrorMessage().connectionError;
  final parsingError = ConstantErrorMessage().parsingError;

  test(
    'pastikan output dari initialState',
    () async {
      // assert
      expect(
        bloc.state,
        InitialProjectState(),
      );
    },
  );

  group('load data project', () {
    const tUserId = 'testUserId';
    final tParams = ParamsGetProject(userId: tUserId);
    final tEvent = LoadDataProjectEvent();
    final tResponse = ProjectResponse.fromJson(
      json.decode(
        fixture('project_response.json'),
      ),
    );

    void buildMockSharedPreferences() {
      when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyUserId)).thenReturn(tUserId);
    }

    void verifyMockSharedPreferences() {
      verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyUserId));
    }

    blocTest(
      'pastikan emit [LoadingProjectState, SuccessLoadDataProjectState] ketika terima event '
      'LoadDataProjectEvent dengan proses berhasil',
      build: () {
        buildMockSharedPreferences();
        when(mockGetProject(any)).thenAnswer((_) async => Right(tResponse));
        return bloc;
      },
      act: (ProjectBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingProjectState(),
        SuccessLoadDataProjectState(project: tResponse),
      ],
      verify: (_) {
        verifyMockSharedPreferences();
        verify(mockGetProject(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingProjectState, FailureProjectState] ketika terima event '
      'LoadDataProjectEvent dengan nilai userId tidak valid',
      build: () {
        when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyUserId)).thenReturn(null);
        return bloc;
      },
      act: (ProjectBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingProjectState(),
        FailureProjectState(errorMessage: 'invalid_user_id'),
      ],
      verify: (_) {
        verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyUserId));
      },
    );

    blocTest(
      'pastikan emit [LoadingProjectState, FailureProjectState] ketika terima event '
      'LoadDataProjectEvent dengan respon gagal dari endpoint',
      build: () {
        buildMockSharedPreferences();
        when(mockGetProject(any)).thenAnswer((_) async => Left(ServerFailure(errorMessage)));
        return bloc;
      },
      act: (ProjectBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingProjectState(),
        FailureProjectState(errorMessage: errorMessage),
      ],
      verify: (_) {
        verifyMockSharedPreferences();
        verify(mockGetProject(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingProjectState, FailureProjectState] ketika terima event '
      'LoadDataProjectEvent dengan kondisi internet tidak terhubung',
      build: () {
        buildMockSharedPreferences();
        when(mockGetProject(any)).thenAnswer((_) async => Left(ConnectionFailure()));
        return bloc;
      },
      act: (ProjectBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingProjectState(),
        FailureProjectState(errorMessage: connectionError),
      ],
      verify: (_) {
        verifyMockSharedPreferences();
        verify(mockGetProject(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingProjectState, FailureProjectState] ketika terima event '
      'LoadDataProjectEvent dengan proses gagal parsing respon dari endpoint',
      build: () {
        buildMockSharedPreferences();
        when(mockGetProject(any)).thenAnswer((_) async => Left(ParsingFailure(errorMessage)));
        return bloc;
      },
      act: (ProjectBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingProjectState(),
        FailureProjectState(errorMessage: parsingError),
      ],
      verify: (_) {
        verifyMockSharedPreferences();
        verify(mockGetProject(tParams));
      },
    );
  });
}
