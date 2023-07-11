import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';

abstract class SettingRepository {
  Future<({Failure? failure, KvSettingResponse? response})> getKvSetting();

  Future<({Failure? failure, bool? response})> setKvSetting(KvSettingBody body);
}