import 'package:dipantau_desktop_client/feature/data/model/detail_project/detail_project_response_bak.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_response_bak.g.dart';

// TODO: hapus file ini
@JsonSerializable()
class ProjectResponseBak extends Equatable {
  @JsonKey(name: 'data')
  final List<DetailProjectResponseBak> data;

  ProjectResponseBak({
    required this.data,
  });

  factory ProjectResponseBak.fromJson(Map<String, dynamic> json) => _$ProjectResponseBakFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectResponseBakToJson(this);

  @override
  List<Object?> get props => [
        data,
      ];

  @override
  String toString() {
    return 'ProjectResponseBak{data: $data}';
  }
}
