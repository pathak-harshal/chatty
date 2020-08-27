import 'package:chatty/blocs/group/show_group/show_group_bloc.dart';
import 'package:chatty/blocs/group/show_group/show_group_event.dart';
import 'package:chatty/blocs/group/show_group/show_group_state.dart';
import 'package:chatty/models/group/group.dart';
import 'package:chatty/models/message/message.dart';
import 'package:chatty/services/null_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowGroupScreen extends StatefulWidget {
  final Group group;

  ShowGroupScreen({
    @required final this.group,
  });

  @override
  _ShowGroupScreenState createState() {
    return _ShowGroupScreenState();
  }
}

class _ShowGroupScreenState extends State<ShowGroupScreen> {
  final TextEditingController _bodyController = TextEditingController();

  ShowGroupBloc _showGroupBloc;

  @override
  void initState() {
    _bodyController.addListener(() {
      setState(() {});
    });

    _showGroupBloc = ShowGroupBloc(
      group: widget.group,
    );

    _showGroupBloc.add(LoadShowGroup());

    super.initState();
  }

  @override
  void dispose() {
    _bodyController.dispose();

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<ShowGroupBloc>(
      create: (final BuildContext context) {
        return _showGroupBloc;
      },
      child: BlocBuilder<ShowGroupBloc, ShowGroupState>(
        builder: (
          final BuildContext context,
          final ShowGroupState state,
        ) {
          return Scaffold(
            appBar: _appBar(state),
            body: _body(state),
          );
        },
      ),
    );
  }

  AppBar _appBar(final ShowGroupState state) {
    if (state is ShowGroupLoaded) {
      return AppBar(
        title: Text(_showGroupBloc.group.name),
        actions: [
          if (_showGroupBloc.selectedMessages.length > 0)
            Row(
              children: [
                if (_showGroupBloc.copyableMessages.length > 0)
                  IconButton(
                    icon: Icon(Icons.content_copy),
                    onPressed: () {
                      _showGroupBloc.add(CopyMessages());
                    },
                  ),
                if (_showGroupBloc.archivableMessages.length > 0)
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    onPressed: () {
                      _showGroupBloc.add(
                        ArchiveMessages(),
                      );
                    },
                  ),
              ],
            ),
        ],
      );
    } else {
      return AppBar(
        title: Text('Loading'),
      );
    }
  }

  Widget _body(final ShowGroupState state) {
    if (state is ShowGroupLoaded) {
      return WillPopScope(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemBuilder: (final BuildContext context, final int index) {
                  return ListTile(
                    key: ValueKey(_showGroupBloc.messages[index].updatedAt),
                    title: Text(_showGroupBloc.messages[index].userName),
                    subtitle: Text(
                      _showGroupBloc.messages[index].scrubbedBody,
                    ),
                    onTap: () {
                      if (_showGroupBloc.selectedMessages.length > 0) {
                        if (_showGroupBloc.messages[index].selected) {
                          _showGroupBloc.add(
                            DeselectMessage(
                              message: _showGroupBloc.messages[index],
                            ),
                          );
                        } else {
                          _showGroupBloc.add(
                            SelectMessage(
                              message: _showGroupBloc.messages[index],
                            ),
                          );
                        }
                      }
                    },
                    onLongPress: () {
                      _showGroupBloc.add(
                        SelectMessage(
                          message: _showGroupBloc.messages[index],
                        ),
                      );
                    },
                    selected: _showGroupBloc.messages[index].selected,
                  );
                },
                itemCount: _showGroupBloc.messages.length,
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                ),
                keyboardType: TextInputType.multiline,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1024),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.send),
                onPressed: blank(_bodyController.text)
                    ? null
                    : () {
                        _showGroupBloc.add(
                          CreateMessage(
                            message: Message(
                              body: _bodyController.text.trim(),
                            ),
                          ),
                        );

                        _bodyController.clear();
                      },
              ),
            ),
          ],
        ),
        onWillPop: () async {
          if (_showGroupBloc.selectedMessages.length > 0) {
            _showGroupBloc.add(
              DeselectMessages(),
            );

            return false;
          } else {
            return true;
          }
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
