import 'package:chatty/blocs/group/group_bloc.dart';
import 'package:chatty/blocs/group/group_event.dart';
import 'package:chatty/blocs/group/group_state.dart';
import 'package:chatty/services/null_checker.dart';
import 'package:chatty/services/wayfinder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() {
    return _GroupScreenState();
  }
}

class _GroupScreenState extends State<GroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  GroupBloc _groupBloc;

  @override
  void initState() {
    _groupBloc = GroupBloc()..add(LoadGroup());

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<GroupBloc>(
      create: (final BuildContext context) {
        return _groupBloc;
      },
      child: BlocBuilder<GroupBloc, GroupState>(
        builder: (
          final BuildContext context,
          final GroupState state,
        ) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Groups'),
              actions: [
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    _groupBloc.add(SignOut());
                  },
                )
              ],
            ),
            body: _body(state),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Wayfinder.instance.newGroup();
              },
              icon: Icon(Icons.add),
              label: Text('New group'),
            ),
          );
        },
      ),
    );
  }

  Widget _body(final GroupState state) {
    if (state is GroupLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return RefreshIndicator(
        child: ListView.builder(
          itemBuilder: (
            final BuildContext context,
            final int index,
          ) {
            return ListTile(
              title: Text(_groupBloc.groups[index].name),
              subtitle: blank(_groupBloc.groups[index].preview)
                  ? null
                  : Text(_groupBloc.groups[index].preview),
              onTap: () {
                Wayfinder.instance.showGroup(
                  group: _groupBloc.groups[index],
                );
              },
            );
          },
          itemCount: _groupBloc.groups.length,
        ),
        onRefresh: () async {
          _groupBloc.add(LoadGroup());
        },
      );
    }
  }
}
