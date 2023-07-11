import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/setting/setting_repository.dart';
import 'package:equatable/equatable.dart';

class SetKvSetting implements UseCaseRecords<bool?, ParamsSetKvSetting> {
  final SettingRepository repository;

  SetKvSetting({required this.repository});

  @override
  Future<({Failure? failure, bool? response})> call(ParamsSetKvSetting params) async {
    return repository.setKvSetting(params.body);
  }
}

class ParamsSetKvSetting extends Equatable {
  final KvSettingBody body;

  ParamsSetKvSetting({
    required this.body,
  });

  @override
  List<Object?> get props => [
        body,
      ];

  @override
  String toString() {
    return 'ParamsSetKvSetting{body: $body}';
  }
}
