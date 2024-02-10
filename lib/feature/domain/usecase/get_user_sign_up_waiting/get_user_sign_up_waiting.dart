import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_waiting/user_sign_up_waiting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/user/user_repository.dart';

class GetUserSignUpWaiting implements UseCaseRecords<UserSignUpWaitingResponse, NoParams> {
  final UserRepository repository;

  GetUserSignUpWaiting({required this.repository});

  @override
  Future<({Failure? failure, UserSignUpWaitingResponse? response})> call(NoParams params) {
    return repository.getUserSignUpWaiting();
  }
}