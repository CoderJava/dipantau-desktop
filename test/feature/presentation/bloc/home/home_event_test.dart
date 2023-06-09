import 'package:dipantau_desktop_client/feature/presentation/bloc/home/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadDataHomeEvent', () {
    final tEvent = LoadDataHomeEvent(
      date: 'testDate',
      projectId: 'testProjectId',
    );

    test(
      'pastikan output dari nilai props',
      () async {
        // assert
        expect(
          tEvent.props,
          [
            tEvent.date,
            tEvent.projectId,
          ],
        );
      },
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'LoadDataHomeEvent{date: ${tEvent.date}, projectId: ${tEvent.projectId}}',
        );
      },
    );
  });
}
