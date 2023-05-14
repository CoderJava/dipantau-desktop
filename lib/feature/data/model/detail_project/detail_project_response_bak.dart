import 'package:dipantau_desktop_client/feature/data/model/detail_task/detail_task_response_bak.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_project_response_bak.g.dart';

// TODO: Hapus file ini karena ini file fake json
@JsonSerializable()
class DetailProjectResponseBak extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'tracked_in_seconds')
  final int? trackedInSeconds;
  @JsonKey(name: 'list_tasks')
  final List<DetailTaskResponseBak>? listTasks;

  DetailProjectResponseBak({
    required this.id,
    required this.name,
    required this.trackedInSeconds,
    required this.listTasks,
  });

  factory DetailProjectResponseBak.fromJson(Map<String, dynamic> json) => _$DetailProjectResponseBakFromJson(json);

  Map<String, dynamic> toJson() => _$DetailProjectResponseBakToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        trackedInSeconds,
        listTasks,
      ];

  @override
  String toString() {
    return 'DetailProjectResponseBak{id: $id, name: $name, trackedInSeconds: $trackedInSeconds, listTasks: $listTasks}';
  }
}
