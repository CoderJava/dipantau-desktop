import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_body.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/setting/setting_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateUserSetting implements UseCaseRecords<bool?, ParamsUpdateUserSetting> {
  final SettingRepository repository;

  UpdateUserSetting({required this.repository});

  @override
  Future<({Failure? failure, bool? response})> call(ParamsUpdateUserSetting params) {
    return repository.updateUserSetting(params.body);
  }
}

class ParamsUpdateUserSetting extends Equatable {
  final UserSettingBody body;

  ParamsUpdateUserSetting({
    required this.body,
  });

  @override
  List<Object?> get props => [
    body,
  ];

  @override
  String toString() {
    return 'ParamsUpdateUserSetting{body: $body}';
  }
}
