import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bulk_create_track_image_body.g.dart';

@JsonSerializable()
class BulkCreateTrackImageBody extends Equatable {
  @JsonKey(name: 'files')
  final List<String> files;

  BulkCreateTrackImageBody({required this.files});

  factory BulkCreateTrackImageBody.fromJson(Map<String, dynamic> json) => _$BulkCreateTrackImageBodyFromJson(json);

  Map<String, dynamic> toJson() => _$BulkCreateTrackImageBodyToJson(this);

  @override
  List<Object?> get props => [
    files,
  ];

  @override
  String toString() {
    return 'BulkCreateTrackImageBody{files: $files}';
  }
}