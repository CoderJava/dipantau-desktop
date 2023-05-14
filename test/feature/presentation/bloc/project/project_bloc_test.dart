import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/project/project_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
