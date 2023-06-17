import 'package:dipantau_desktop_client/feature/database/entity/track/track.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tEntity = Track(
    id: 0,
    userId: "testUserId",
    taskId: 0,
    startDate: "testStartDate",
    finishDate: "testFinishDate",
    activity: 0,
    files: "testFiles",
    duration: 0,
  );

  test(
    'pastikan output dari fungsi toString',
    () async {
      // assert
      expect(
        tEntity.toString(),
        'Track{id: ${tEntity.id}, userId: ${tEntity.userId}, taskId: ${tEntity.taskId}, startDate: ${tEntity.startDate}, '
        'finishDate: ${tEntity.finishDate}, activity: ${tEntity.activity}, files: ${tEntity.files}, '
        'duration: ${tEntity.duration}}',
      );
    },
  );
}
