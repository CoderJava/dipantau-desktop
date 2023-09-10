import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/all_user_setting/all_user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';

abstract class SettingRepository {
  Future<({Failure? failure, KvSettingResponse? response})> getKvSetting();

  Future<({Failure? failure, bool? response})> setKvSetting(KvSettingBody body);

  Future<({Failure? failure, AllUserSettingResponse? response})> getAllUserSetting();
}