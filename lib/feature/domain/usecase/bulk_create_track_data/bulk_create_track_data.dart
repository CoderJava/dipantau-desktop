import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/track/track_repository.dart';
import 'package:equatable/equatable.dart';

class BulkCreateTrackData implements UseCaseRecords<GeneralResponse?, ParamsBulkCreateTrackData> {
  final TrackRepository repository;

  BulkCreateTrackData({required this.repository});

  @override
  Future<({Failure? failure, GeneralResponse? response})> call(ParamsBulkCreateTrackData params) async {
    return repository.bulkCreateTrackData(params.body);
  }
}

class ParamsBulkCreateTrackData extends Equatable {
  final BulkCreateTrackDataBody body;

  ParamsBulkCreateTrackData({required this.body});

  @override
  List<Object?> get props => [
        body,
      ];

  @override
  String toString() {
    return 'ParamsBulkCreateTrackData{body: $body}';
  }
}
