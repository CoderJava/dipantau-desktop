import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manual_create_track_body.g.dart';

@JsonSerializable()
class ManualCreateTrackBody extends Equatable {
  @JsonKey(name: 'task_id')
  final int taskId;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'finish_date')
  final String finishDate;
  @JsonKey(name: 'duration')
  final int duration;
  @JsonKey(name: 'note')
  final String? note;

  ManualCreateTrackBody({
    required this.taskId,
    required this.startDate,
    required this.finishDate,
    required this.duration,
    required this.note,
  });

  factory ManualCreateTrackBody.fromJson(Map<String, dynamic> json) => _$ManualCreateTrackBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ManualCreateTrackBodyToJson(this);

  @override
  List<Object?> get props => [
        taskId,
        startDate,
        finishDate,
        duration,
        note,
      ];

  @override
  String toString() {
    return 'ManualCreateTrackBody{taskId: $taskId, startDate: $startDate, finishDate: $finishDate, duration: $duration, '
        'note: $note}';
  }
}
