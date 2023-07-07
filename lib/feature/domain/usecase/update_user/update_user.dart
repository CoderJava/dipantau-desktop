import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/user/user_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateUser implements UseCaseRecords<bool?, ParamsUpdateUser> {
  final UserRepository repository;

  UpdateUser({required this.repository});

  @override
  Future<({Failure? failure, bool? response})> call(ParamsUpdateUser params) {
    return repository.updateUser(params.body, params.id);
  }
}

class ParamsUpdateUser extends Equatable {
  final UpdateUserBody body;
  final int id;

  ParamsUpdateUser({
    required this.body,
    required this.id,
  });

  @override
  List<Object?> get props => [
    body,
    id,
  ];

  @override
  String toString() {
    return 'ParamsUpdateUser{body: $body, id: $id}';
  }
}
