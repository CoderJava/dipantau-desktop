import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dipantau_desktop_client/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helper/mock_helper.mocks.dart';

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(mockConnectivity);
  });

  test(
    'pastikan fungsi checkConnectivity benar-benar terpanggil dengan kondisi koneksi '
    'menggunakan mobile data',
    () async {
      // arrange
      final tHasConnection = [ConnectivityResult.mobile];
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => tHasConnection);

      // act
      final result = await networkInfoImpl.isConnected;

      // assert
      verify(mockConnectivity.checkConnectivity());
      expect(result, true);
    },
  );

  test(
    'pastikan fungsi checkConnectivity benar-benar terpanggil dengan kondisi koneksi '
    'menggunakan wifi',
    () async {
      // arrange
      final tHasConnection = [ConnectivityResult.wifi];
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => tHasConnection);

      // act
      final result = await networkInfoImpl.isConnected;

      // assert
      verify(mockConnectivity.checkConnectivity());
      expect(result, true);
    },
  );

  test(
    'pastikan fungsi checkConnectivity benar-benar terpanggil dengan kondisi koneksi '
    'tidak terhubung sama sekali',
    () async {
      // arrange
      final tHasConnection = [ConnectivityResult.none];
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => tHasConnection);

      // act
      final result = await networkInfoImpl.isConnected;

      // assert
      verify(mockConnectivity.checkConnectivity());
      expect(result, false);
    },
  );
}
