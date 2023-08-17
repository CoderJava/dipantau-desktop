import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/user/user_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/user_version/user_version_body.dart';
import 'package:equatable/equatable.dart';

class SendAppVersion implements UseCaseRecords<bool?, ParamsSendAppVersion> {
  final UserRepository repository;

  SendAppVersion({required this.repository});

  @override
  Future<({Failure? failure, bool? response})> call(ParamsSendAppVersion params) {
    return repository.sendAppVersion(params.body);
  }
}

class ParamsSendAppVersion extends Equatable {
  final UserVersionBody body;

  ParamsSendAppVersion({required this.body});

  @override
  List<Object?> get props => [
        body,
      ];

  @override
  String toString() {
    return 'ParamsSendAppVersion{body: $body}';
  }
}
