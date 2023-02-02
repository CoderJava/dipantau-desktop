import 'package:dipantau_desktop_client/feature/data/model/detail_task/detail_task_response.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_project_response.g.dart';

@JsonSerializable()
class DetailProjectResponse extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'tracked_in_seconds')
  final int? trackedInSeconds;
  @JsonKey(name: 'list_tasks')
  final List<DetailTaskResponse>? listTasks;

  DetailProjectResponse({
    required this.id,
    required this.name,
    required this.trackedInSeconds,
    required this.listTasks,
  });

  factory DetailProjectResponse.fromJson(Map<String, dynamic> json) => _$DetailProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailProjectResponseToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        trackedInSeconds,
        listTasks,
      ];

  @override
  String toString() {
    return 'DetailProjectResponse{id: $id, name: $name, trackedInSeconds: $trackedInSeconds, listTasks: $listTasks}';
  }
}
