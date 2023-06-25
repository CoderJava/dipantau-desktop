import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/appearance/appearance_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppearanceBloc bloc;

  setUp(() {
    bloc = AppearanceBloc();
  });

  test(
    'pastikan output dari nilai initialState',
    () async {
      // assert
      expect(
        bloc.state,
        isA<InitialAppearanceState>(),
      );
    },
  );

  group('update appearance', () {
    blocTest(
      'pastikan emit [UpdatedAppearanceState] ketika terima event AppearanceEvent',
      build: () {
        return bloc;
      },
      act: (AppearanceBloc bloc) {
        return bloc.add(UpdateAppearanceEvent(isDarkMode: true));
      },
      expect: () => [
        isA<UpdatedAppearanceState>(),
      ],
    );
  });
}
