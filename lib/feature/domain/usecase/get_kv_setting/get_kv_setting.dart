import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/setting/setting_repository.dart';

class GetKvSetting implements UseCaseRecords<KvSettingResponse?, NoParams> {
  final SettingRepository repository;

  GetKvSetting({required this.repository});

  @override
  Future<({Failure? failure, KvSettingResponse? response})> call(NoParams params) async {
    return repository.getKvSetting();
  }
}
