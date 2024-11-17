import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/general/general_repository.dart';
import 'package:equatable/equatable.dart';

class Ping implements UseCaseRecords<GeneralResponse, ParamsPing> {
  final GeneralRepository repository;

  Ping({required this.repository});

  @override
  Future<({Failure? failure, GeneralResponse? response})> call(ParamsPing params) {
    return repository.ping(params.baseUrl);
  }
}

class ParamsPing extends Equatable {
  final String baseUrl;

  ParamsPing({
    required this.baseUrl,
  });

  @override
  List<Object?> get props => [
        baseUrl,
      ];

  @override
  String toString() {
    return 'ParamsPing{baseUrl: $baseUrl}';
  }
}
