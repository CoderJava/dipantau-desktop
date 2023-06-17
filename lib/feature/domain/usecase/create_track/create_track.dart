import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/track/track_repository.dart';
import 'package:equatable/equatable.dart';

class CreateTrack implements UseCaseRecords<GeneralResponse?, ParamsCreateTrack> {
  final TrackRepository repository;

  CreateTrack({required this.repository});

  @override
  Future<({Failure? failure, GeneralResponse? response})> call(ParamsCreateTrack params) async {
    return repository.createTrack(params.body);
  }
}

class ParamsCreateTrack extends Equatable {
  final CreateTrackBody body;

  ParamsCreateTrack({required this.body});

  @override
  List<Object?> get props => [
        body,
      ];

  @override
  String toString() {
    return 'ParamsCreateTrack{body: $body}';
  }
}
