import 'package:meta/meta.dart';

abstract class GroupEvent {}

class LoadGroup extends GroupEvent {}

class LoadGroups extends GroupEvent {
  final DateTime since;

  LoadGroups({
    @required final this.since,
  });
}

class SignOut extends GroupEvent {}
