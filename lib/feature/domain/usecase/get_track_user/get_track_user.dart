import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user/track_user_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/track/track_repository.dart';
import 'package:equatable/equatable.dart';

class GetTrackUser implements UseCaseRecords<TrackUserResponse?, ParamsGetTrackUser> {
  final TrackRepository repository;

  GetTrackUser({required this.repository});

  @override
  Future<({Failure? failure, TrackUserResponse? response})> call(ParamsGetTrackUser params) async {
    return repository.getTrackUser(params.userId, params.date);
  }
}

class ParamsGetTrackUser extends Equatable {
  final String userId;
  final String date;

  ParamsGetTrackUser({
    required this.userId,
    required this.date,
  });

  @override
  List<Object?> get props => [
        userId,
        date,
      ];

  @override
  String toString() {
    return 'ParamsGetTrackUser{userId: $userId, date: $date}';
  }
}
