part of 'user_profile_bloc.dart';

abstract class UserProfileEvent {}

class LoadDataUserProfileEvent extends UserProfileEvent {}

class UpdateDataUserProfileEvent extends UserProfileEvent {
  final UpdateUserBody body;
  final int id;

  UpdateDataUserProfileEvent({
    required this.body,
    required this.id,
  });

  @override
  String toString() {
    return 'UpdateDataUserProfileEvent{body: $body, id: $id}';
  }
}
