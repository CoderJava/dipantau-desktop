import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/general/general_repository.dart';

class Ping implements UseCaseRecords<GeneralResponse, NoParams> {
  final GeneralRepository repository;

  Ping({required this.repository});

  @override
  Future<({Failure? failure, GeneralResponse? response})> call(NoParams params) {
    return repository.ping();
  }
}