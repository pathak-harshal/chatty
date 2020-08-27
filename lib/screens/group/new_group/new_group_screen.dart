import 'package:chatty/blocs/group/new_group/new_group_bloc.dart';
import 'package:chatty/blocs/group/new_group/new_group_event.dart';
import 'package:chatty/blocs/group/new_group/new_group_state.dart';
import 'package:chatty/models/group/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewGroupScreen extends StatefulWidget {
  @override
  _NewGroupScreenState createState() {
    return _NewGroupScreenState();
  }
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  NewGroupBloc _newGroupBloc;

  @override
  void initState() {
    _newGroupBloc = NewGroupBloc()..add(LoadNewGroup());

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<NewGroupBloc>(
      create: (final BuildContext context) {
        return _newGroupBloc;
      },
      child: BlocBuilder<NewGroupBloc, NewGroupState>(
        builder: (
          final BuildContext context,
          final NewGroupState state,
        ) {
          return Scaffold(
            appBar: AppBar(
              title: Text('New group'),
            ),
            body: Center(
              child: ListTile(
                title: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'e.g. GraphQL BLR 2020',
                  ),
                  autofocus: true,
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                _newGroupBloc.add(
                  CreateGroup(
                    group: Group(name: _nameController.text),
                  ),
                );
              },
              icon: Icon(Icons.save),
              label: Text('Create group'),
            ),
          );
        },
      ),
    );
  }
}
