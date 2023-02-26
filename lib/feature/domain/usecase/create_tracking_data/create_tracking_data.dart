import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/tracking_data/tracking_data_body.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/general/general_repository.dart';
import 'package:equatable/equatable.dart';

class CreateTrackingData implements UseCase<GeneralResponse, ParamsCreateTrackingData> {
  final GeneralRepository generalRepository;

  CreateTrackingData({required this.generalRepository});

  @override
  Future<Either<Failure, GeneralResponse>> call(ParamsCreateTrackingData params) {
    return generalRepository.createTrackingData(params.body);
  }
}

class ParamsCreateTrackingData extends Equatable {
  final TrackingDataBody body;

  ParamsCreateTrackingData({required this.body});

  @override
  List<Object?> get props => [
    body,
  ];

  @override
  String toString() {
    return 'ParamsCreateTrackingData{body: $body}';
  }
}