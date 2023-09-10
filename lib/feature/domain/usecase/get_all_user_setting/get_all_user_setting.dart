import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/all_user_setting/all_user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/setting/setting_repository.dart';

class GetAllUserSetting implements UseCaseRecords<AllUserSettingResponse?, NoParams> {
  final SettingRepository repository;

  GetAllUserSetting({required this.repository});

  @override
  Future<({Failure? failure, AllUserSettingResponse? response})> call(NoParams params) {
    return repository.getAllUserSetting();
  }
}