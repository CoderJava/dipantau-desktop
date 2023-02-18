// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_task_response.g.dart';

@JsonSerializable()
class DetailTaskResponse extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'tracked_in_seconds')
  int? trackedInSeconds;

  DetailTaskResponse({
    required this.id,
    required this.name,
    required this.trackedInSeconds,
  });

  factory DetailTaskResponse.fromJson(Map<String, dynamic> json) => _$DetailTaskResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailTaskResponseToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        trackedInSeconds,
      ];

  @override
  String toString() {
    return 'DetailTaskResponse{id: $id, name: $name, trackedInSeconds: $trackedInSeconds}';
  }
}
