import 'package:floor/floor.dart';

@Entity(tableName: 'track')
class Track {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  @ColumnInfo(name: 'user_id')
  final String userId;
  @ColumnInfo(name: 'task_id')
  final int taskId;
  @ColumnInfo(name: 'start_date')
  final String startDate;
  @ColumnInfo(name: 'finish_date')
  final String finishDate;
  @ColumnInfo(name: 'activity')
  final int activity;
  @ColumnInfo(name: 'files')
  final String files;
  @ColumnInfo(name: 'duration')
  final int duration;
  @ColumnInfo(name: 'project_name')
  final String projectName;
  @ColumnInfo(name: 'task_name')
  final String taskName;

  Track({
    this.id,
    required this.userId,
    required this.taskId,
    required this.startDate,
    required this.finishDate,
    required this.activity,
    required this.files,
    required this.duration,
    required this.projectName,
    required this.taskName,
  });

  @override
  String toString() {
    return 'Track{id: $id, userId: $userId, taskId: $taskId, startDate: $startDate, finishDate: $finishDate, '
        'activity: $activity, files: $files, duration: $duration, projectName: $projectName, taskName: $taskName}';
  }
}
