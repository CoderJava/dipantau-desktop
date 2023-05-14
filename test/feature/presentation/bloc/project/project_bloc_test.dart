import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response_bak.dart';
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
    const tEmail = 'testEmail';
    final tParams = ParamsGetProject(email: tEmail);
    final tEvent = LoadDataProjectEvent();
    final tResponse = ProjectResponseBak.fromJson(
      json.decode(
        fixture('project_response.json'),
      ),
    );

    blocTest(
      'pastikan emit [LoadingProjectState, SuccessLoadDataProjectState] ketika terima event '
      'LoadDataProjectEvent dengan proses berhasil',
      build: () {
        when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail)).thenReturn(tEmail);
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
        verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail));
        verify(mockGetProject(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingProjectState, FailureProjectState] ketika terima event '
      'LoadDataProjectEvent dengan nilai email tidak valid',
      build: () {
        when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail)).thenReturn('');
        return bloc;
      },
      act: (ProjectBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingProjectState(),
        FailureProjectState(errorMessage: 'Error: Invalid email. Please relogin to fix it.'),
      ],
      verify: (_) {
        verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail));
      },
    );

    blocTest(
      'pastikan emit [LoadingProjectState, FailureProjectState] ketika terima event '
      'LoadDataProjectEvent dengan proses gagal dari endpoint',
      build: () {
        when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail)).thenReturn(tEmail);
        when(mockGetProject(any)).thenAnswer((_) async => Left(ServerFailure('testErrorMessage')));
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
        verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail));
        verify(mockGetProject(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingProjectState, FailureProjectState] ketika terima event '
      'LoadDataProjectEvent dengan kondisi internet tidak terhubung ketika hit endpoint',
      build: () {
        when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail)).thenReturn(tEmail);
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
        verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail));
        verify(mockGetProject(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingProjectState, FailureProjectState] ketika terima event '
      'LoadDataProjectEvent dengan proses gagal parsing respon JSON dari endpoint',
      build: () {
        when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail)).thenReturn(tEmail);
        when(mockGetProject(any)).thenAnswer((_) async => Left(ParsingFailure('testErrorMessage')));
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
        verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyEmail));
        verify(mockGetProject(tParams));
      },
    );
  });
}
