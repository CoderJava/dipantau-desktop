import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_image_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/track/track_repository.dart';
import 'package:equatable/equatable.dart';

class BulkCreateTrackImage implements UseCaseRecords<GeneralResponse?, ParamsBulkCreateTrackImage> {
  final TrackRepository repository;

  BulkCreateTrackImage({required this.repository});

  @override
  Future<({Failure? failure, GeneralResponse? response})> call(ParamsBulkCreateTrackImage params) async {
    return repository.bulkCreateTrackImage(params.body);
  }
}

class ParamsBulkCreateTrackImage extends Equatable {
  final BulkCreateTrackImageBody body;

  ParamsBulkCreateTrackImage({required this.body});

  @override
  List<Object?> get props => [
        body,
      ];

  @override
  String toString() {
    return 'ParamsBulkCreateTrackImage{body: $body}';
  }
}
