import 'dart:async';

import 'package:chatty/blocs/group/group_event.dart';
import 'package:chatty/blocs/group/group_state.dart';
import 'package:chatty/models/group/group.dart';
import 'package:chatty/models/group/group_repo.dart';
import 'package:chatty/services/storage.dart';
import 'package:chatty/services/wayfinder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(GroupLoading());

  final List<Group> groups = [];
  StreamSubscription<DateTime> subscription;

  @override
  Stream<GroupState> mapEventToState(
    final GroupEvent event,
  ) async* {
    if (event is LoadGroup) {
      yield GroupLoading();

      add(LoadGroups(since: DateTime(2020, 8, 27)));
    } else if (event is LoadGroups) {
      final List<Group> group = await GroupRepo.instance.getGroups(
        since: event.since,
      );

      group.forEach((final Group group) {
        if (this.groups.contains(group)) {
          this.groups[this.groups.indexOf(group)] = group;
        } else {
          this.groups.insert(0, group);
        }
      });

      groups.sort((final Group previousGroup, final Group nextGroup) {
        return nextGroup.updatedAt.compareTo(previousGroup.updatedAt);
      });

      subscription ??= GroupRepo.instance.getRemoteMaxima().listen((
        final DateTime remoteMaxima,
      ) {
        final DateTime localMaxima = group.fold<DateTime>(
          DateTime(2020, 8, 27),
          (final DateTime previousValue, final Group group) {
            if (previousValue.isBefore(group.updatedAt)) {
              return group.updatedAt;
            } else {
              return previousValue;
            }
          },
        );

        if (localMaxima.isBefore(remoteMaxima)) {
          add(LoadGroups(since: localMaxima));
        }
      });

      yield GroupLoaded();
    } else if (event is SignOut) {
      Storage.instance.userId = null;

      Wayfinder.instance.signUp();
    }
  }

  @override
  Future<void> close() async {
    await subscription.cancel();

    return super.close();
  }
}
