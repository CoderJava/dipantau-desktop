import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/manual_create_track/manual_create_track_body.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/track/track_repository.dart';
import 'package:equatable/equatable.dart';

class CreateManualTrack implements UseCaseRecords<GeneralResponse?, ParamsCreateManualTrack> {
  final TrackRepository repository;

  CreateManualTrack({required this.repository});

  @override
  Future<({Failure? failure, GeneralResponse? response})> call(ParamsCreateManualTrack params) async {
    return repository.createManualTrack(params.body);
  }
}

class ParamsCreateManualTrack extends Equatable {
  final ManualCreateTrackBody body;

  ParamsCreateManualTrack({required this.body});

  @override
  List<Object?> get props => [
    body,
  ];

  @override
  String toString() {
    return 'ParamsCreateManualTrack{body: $body}';
  }
}
