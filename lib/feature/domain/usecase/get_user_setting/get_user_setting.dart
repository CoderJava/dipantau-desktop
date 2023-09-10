import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/setting/setting_repository.dart';

class GetUserSetting implements UseCaseRecords<UserSettingResponse?, NoParams> {
  final SettingRepository repository;

  GetUserSetting({required this.repository});

  @override
  Future<({Failure? failure, UserSettingResponse? response})> call(NoParams params) {
    return repository.getUserSetting();
  }
}