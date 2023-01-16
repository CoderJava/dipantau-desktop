import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helper/mock_helper.mocks.dart';

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late SharedPreferencesManager sharedPreferencesManager;
  const tKey = 'testKey';

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    sharedPreferencesManager = SharedPreferencesManager.getInstance(mockSharedPreferences);
  });

  test(
    'pastikan fungsi isKeyExists bisa mengecek tersedianya atau tidak nilai dari SharedPreferences',
    () async {
      // arrange
      when(mockSharedPreferences.containsKey(any)).thenReturn(true);

      // act
      var result = sharedPreferencesManager.isKeyExists(tKey);

      // assert
      verify(mockSharedPreferences.containsKey(tKey)).called(1);
      expect(result, true);
    },
  );

  test(
    'pastikan fungsi clearKey bisa menghapus nilai dari SharedPreferences',
    () async {
      // arrange
      when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

      // act
      var result = await sharedPreferencesManager.clearKey(tKey);

      // assert
      verify(mockSharedPreferences.remove(tKey)).called(1);
      expect(result, true);
    },
  );

  test(
    'pastikan fungsi clearAll bisa menghapus semua nilai di SharedPreferences',
    () async {
      // arrange
      when(mockSharedPreferences.clear()).thenAnswer((_) async => true);

      // act
      var result = await sharedPreferencesManager.clearAll();

      // assert
      verify(mockSharedPreferences.clear()).called(1);
      expect(result, true);
    },
  );

  group('bool', () {
    test(
      'pastikan fungsi putBool menyimpan nilai boolean ke SharedPreferences',
      () async {
        // arrange
        when(mockSharedPreferences.setBool(tKey, any)).thenAnswer((_) async => true);

        // act
        await sharedPreferencesManager.putBool(tKey, true);

        // assert
        verify(mockSharedPreferences.setBool(tKey, true)).called(1);
      },
    );

    test(
      'pastikan fungsi getBool mengembalikan nilai boolean dari SharedPreferences',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any)).thenReturn(true);
        when(mockSharedPreferences.getBool(any)).thenReturn(true);

        // act
        var result = sharedPreferencesManager.getBool(tKey);

        // assert
        verify(mockSharedPreferences.getBool(tKey)).called(1);
        expect(result, true);
      },
    );
  });

  group('double', () {
    test(
      'pastikan fungsi putDouble menyimpan nilai double ke SharedPreferences',
      () async {
        // arrange
        when(mockSharedPreferences.setDouble(any, any)).thenAnswer((_) async => true);

        // act
        await sharedPreferencesManager.putDouble(tKey, 1.0);

        // assert
        verify(mockSharedPreferences.setDouble(tKey, 1.0)).called(1);
      },
    );

    test(
      'pastikan fungsi getDouble mengembalikan nilai double dari SharedPreferences',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any)).thenReturn(true);
        when(mockSharedPreferences.getDouble(any)).thenReturn(1.0);

        // act
        var result = sharedPreferencesManager.getDouble(tKey);

        // assert
        verify(mockSharedPreferences.getDouble(tKey)).called(1);
        expect(result, 1.0);
      },
    );
  });

  group('int', () {
    test(
      'pastikan fungsi putInt bisa menyimpan nilai int ke SharedPreferences',
      () async {
        // arrange
        when(mockSharedPreferences.setInt(any, any)).thenAnswer((_) async => true);

        // act
        await sharedPreferencesManager.putInt(tKey, 1);

        // assert
        verify(mockSharedPreferences.setInt(tKey, 1)).called(1);
      },
    );

    test(
      'pastikan fungsi getInt bisa mengembalikan nilai int dari SharedPreferences',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any)).thenReturn(true);
        when(mockSharedPreferences.getInt(any)).thenReturn(1);

        // act
        var result = sharedPreferencesManager.getInt(tKey);

        // assert
        verify(mockSharedPreferences.getInt(tKey)).called(1);
        expect(result, 1);
      },
    );
  });

  group('string', () {
    test(
      'pastikan fungsi putString bisa menyimpan nilai String ke SharedPreferences',
      () async {
        // arrange
        when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

        // act
        await sharedPreferencesManager.putString(tKey, 'testValue');

        // assert
        verify(mockSharedPreferences.setString(tKey, 'testValue')).called(1);
      },
    );

    test(
      'pastikan fungsi getString bisa mengembalikan nilai String dari SharedPreferences',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any)).thenReturn(true);
        when(mockSharedPreferences.getString(any)).thenReturn('testValue');

        // act
        var result = sharedPreferencesManager.getString(tKey);

        // assert
        verify(mockSharedPreferences.getString(tKey));
        expect(result, 'testValue');
      },
    );
  });

  group('stringList', () {
    test(
      'pastikan fungsi putStringList bisa menyimpan nilai list String ke SharedPreferences',
      () async {
        // arrange
        when(mockSharedPreferences.setStringList(any, any)).thenAnswer((_) async => true);

        // act
        await sharedPreferencesManager.putStringList(tKey, ['testValue']);

        // assert
        verify(mockSharedPreferences.setStringList(tKey, ['testValue'])).called(1);
      },
    );

    test(
      'pastikan fungsi getStringList bisa mengembalikan nilai list String dari SharedPreferences',
      () async {
        // arrange
        when(mockSharedPreferences.containsKey(any)).thenReturn(true);
        when(mockSharedPreferences.getStringList(any)).thenReturn(['testValue']);

        // act
        var result = sharedPreferencesManager.getStringList(tKey);

        // assert
        verify(mockSharedPreferences.getStringList(tKey)).called(1);
        expect(result, ['testValue']);
      },
    );
  });
}
