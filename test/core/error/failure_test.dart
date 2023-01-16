import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tErrorMessage = 'testErrorMessage';

  group('ServerFailure', () {
    final tFailure = ServerFailure(tErrorMessage);

    test(
      'pastikan output dari nilai props',
      () async {
        // assert
        expect(
          tFailure.props,
          [
            tFailure.errorMessage,
            tFailure.errorData,
          ],
        );
      },
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tFailure.toString(),
          'ServerFailure{errorMessage: ${tFailure.errorMessage}, errorData: ${tFailure.errorData}}',
        );
      },
    );
  });

  group('ConnectionFailure', () {
    final tFailure = ConnectionFailure();

    test(
      'pastiakn output dari nilai props',
      () async {
        // assert
        expect(
          tFailure.props,
          [
            tFailure.errorMessage,
          ],
        );
      },
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tFailure.toString(),
          'ConnectionFailure{errorMessage: ${tFailure.errorMessage}}',
        );
      },
    );
  });

  group('ParsingFailure', () {
    final tFailure = ParsingFailure(tErrorMessage);

    test(
      'pastikan output dari nilai props',
      () async {
        // assert
        expect(
          tFailure.props,
          [
            tFailure.errorMessage,
          ],
        );
      },
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tFailure.toString(),
          'ParsingFailure{errorMessage: ${tFailure.errorMessage}}',
        );
      },
    );
  });
}
