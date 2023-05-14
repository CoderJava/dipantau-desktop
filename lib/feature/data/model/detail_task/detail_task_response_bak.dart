// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_task_response_bak.g.dart';

// TODO: Hapus file ini karena ini file fake json
@JsonSerializable()
class DetailTaskResponseBak extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'tracked_in_seconds')
  int? trackedInSeconds;

  DetailTaskResponseBak({
    required this.id,
    required this.name,
    required this.trackedInSeconds,
  });

  factory DetailTaskResponseBak.fromJson(Map<String, dynamic> json) => _$DetailTaskResponseBakFromJson(json);

  Map<String, dynamic> toJson() => _$DetailTaskResponseBakToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        trackedInSeconds,
      ];

  @override
  String toString() {
    return 'DetailTaskResponseBak{id: $id, name: $name, trackedInSeconds: $trackedInSeconds}';
  }
}
