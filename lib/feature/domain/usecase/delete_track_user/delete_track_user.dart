import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/track/track_repository.dart';
import 'package:equatable/equatable.dart';

class DeleteTrackUser implements UseCaseRecords<GeneralResponse?, ParamsDeleteTrackUser> {
  final TrackRepository repository;

  DeleteTrackUser({required this.repository});

  @override
  Future<({Failure? failure, GeneralResponse? response})> call(ParamsDeleteTrackUser params) {
    return repository.deleteTrackUser(params.trackId);
  }
}

class ParamsDeleteTrackUser extends Equatable {
  final int trackId;

  ParamsDeleteTrackUser({required this.trackId});

  @override
  List<Object?> get props => [
        trackId,
      ];

  @override
  String toString() {
    return 'ParamsDeleteTrackUser{trackId: $trackId}';
  }
}
