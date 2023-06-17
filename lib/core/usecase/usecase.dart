import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseRecords<Type, Params> {
  Future<({Failure? failure, Type? response})> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
