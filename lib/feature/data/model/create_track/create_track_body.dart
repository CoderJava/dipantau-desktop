import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_track_body.g.dart';

@JsonSerializable()
class CreateTrackBody extends Equatable {
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'task_id')
  final int taskId;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'finish_date')
  final String finishDate;
  @JsonKey(name: 'activity')
  final int activity;
  @JsonKey(name: 'duration')
  final int duration;
  @JsonKey(name: 'files')
  final List<String> files;

  CreateTrackBody({
    required this.userId,
    required this.taskId,
    required this.startDate,
    required this.finishDate,
    required this.activity,
    required this.duration,
    required this.files,
  });

  factory CreateTrackBody.fromJson(Map<String, dynamic> json) => _$CreateTrackBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTrackBodyToJson(this);

  @override
  List<Object?> get props => [
        userId,
        taskId,
        startDate,
        finishDate,
        activity,
        duration,
        files,
      ];

  @override
  String toString() {
    return 'CreateTrackBody{userId: $userId, taskId: $taskId, startDate: $startDate, finishDate: $finishDate, '
        'activity: $activity, duration: $duration, files: $files}';
  }
}
