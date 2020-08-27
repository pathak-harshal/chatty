import 'package:chatty/models/group/group.dart';
import 'package:meta/meta.dart';

abstract class NewGroupEvent {}

class LoadNewGroup extends NewGroupEvent {}

class CreateGroup extends NewGroupEvent {
  final Group group;

  CreateGroup({
    @required final this.group,
  });
}
