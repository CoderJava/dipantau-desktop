import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';

abstract class GeneralRepository {
  Future<({Failure? failure, GeneralResponse? response})> ping(String baseUrl);
}