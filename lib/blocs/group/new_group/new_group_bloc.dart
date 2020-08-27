import 'package:chatty/blocs/group/new_group/new_group_event.dart';
import 'package:chatty/blocs/group/new_group/new_group_state.dart';
import 'package:chatty/models/group/group_repo.dart';
import 'package:chatty/services/wayfinder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewGroupBloc extends Bloc<NewGroupEvent, NewGroupState> {
  NewGroupBloc() : super(NewGroupLoaded());

  @override
  Stream<NewGroupState> mapEventToState(
    final NewGroupEvent event,
  ) async* {
    if (event is LoadNewGroup) {
      yield NewGroupLoaded();
    } else if (event is CreateGroup) {
      Wayfinder.instance.pop();

      GroupRepo.instance.createGroup(
        group: event.group,
      );
    }
  }
}
