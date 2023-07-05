import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/user/user_repository.dart';

class GetAllMember implements UseCaseRecords<ListUserProfileResponse?, NoParams> {
  final UserRepository repository;

  GetAllMember({required this.repository});

  @override
  Future<({Failure? failure, ListUserProfileResponse? response})> call(NoParams params) {
    return repository.getAllMembers();
  }
}