import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bulk_create_track_data_body.g.dart';

@JsonSerializable()
class BulkCreateTrackDataBody extends Equatable {
  @JsonKey(name: 'data')
  final List<ItemBulkCreateTrackDataBody> data;

  BulkCreateTrackDataBody({required this.data});

  factory BulkCreateTrackDataBody.fromJson(Map<String, dynamic> json) => _$BulkCreateTrackDataBodyFromJson(json);

  Map<String, dynamic> toJson() => _$BulkCreateTrackDataBodyToJson(this);

  @override
  List<Object?> get props => [
        data,
      ];

  @override
  String toString() {
    return 'BulkCreateTrackDataBody{data: $data}';
  }
}

@JsonSerializable()
class ItemBulkCreateTrackDataBody extends Equatable {
  @JsonKey(name: 'id', includeFromJson: false, includeToJson: false)
  final int? id;
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
  @JsonKey(name: 'list_file_name')
  final List<String> listFileName;

  ItemBulkCreateTrackDataBody({
    this.id,
    required this.taskId,
    required this.startDate,
    required this.finishDate,
    required this.activity,
    required this.duration,
    required this.listFileName,
  });

  factory ItemBulkCreateTrackDataBody.fromJson(Map<String, dynamic> json) =>
      _$ItemBulkCreateTrackDataBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ItemBulkCreateTrackDataBodyToJson(this);

  @override
  List<Object?> get props => [
        id,
        taskId,
        startDate,
        finishDate,
        activity,
        duration,
        listFileName,
      ];

  @override
  String toString() {
    return 'ItemBulkCreateTrackDataBody{id: $id, taskId: $taskId, startDate: $startDate, finishDate: $finishDate, '
        'activity: $activity, duration: $duration, listFileName: $listFileName}';
  }
}
