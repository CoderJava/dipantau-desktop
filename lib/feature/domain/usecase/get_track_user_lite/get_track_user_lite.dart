import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/track/track_repository.dart';
import 'package:equatable/equatable.dart';

class GetTrackUserLite implements UseCase<TrackUserLiteResponse, ParamsGetTrackUserLite> {
  final TrackRepository repository;

  GetTrackUserLite({
    required this.repository,
  });

  @override
  Future<Either<Failure, TrackUserLiteResponse>> call(ParamsGetTrackUserLite params) {
    return repository.getTrackUserLite(
      params.date,
      params.projectId,
    );
  }
}

class ParamsGetTrackUserLite extends Equatable {
  final String date;
  final String projectId;

  ParamsGetTrackUserLite({
    required this.date,
    required this.projectId,
  });

  @override
  List<Object?> get props => [
        date,
        projectId,
      ];

  @override
  String toString() {
    return 'ParamsGetTrackUserLite{date: $date, projectId: $projectId}';
  }
}
