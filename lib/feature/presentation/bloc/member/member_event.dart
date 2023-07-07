part of 'member_bloc.dart';

abstract class MemberEvent {}

class LoadListMemberEvent extends MemberEvent {}

class EditMemberEvent extends MemberEvent {
  final UpdateUserBody body;
  final int id;

  EditMemberEvent({
    required this.body,
    required this.id,
  });

  @override
  String toString() {
    return 'EditMemberEvent{body: $body, id: $id}';
  }
}
