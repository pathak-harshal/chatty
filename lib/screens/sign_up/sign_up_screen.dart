import 'package:chatty/blocs/sign_up/sign_up_bloc.dart';
import 'package:chatty/blocs/sign_up/sign_up_event.dart';
import 'package:chatty/blocs/sign_up/sign_up_state.dart';
import 'package:chatty/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/toaster.dart';
import '../../services/toaster.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  SignUpBloc _signUpBloc;

  @override
  void initState() {
    _signUpBloc = SignUpBloc()..add(LoadSignUp());

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (final BuildContext context) {
        return _signUpBloc;
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (
          final BuildContext context,
          final SignUpState state,
        ) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Sign up'),
            ),
            body: _body(state),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                var name = _nameController.text;
                if (name.isNotEmpty) {
                  _signUpBloc.add(
                    CreateUser(
                      user: User(name: _nameController.text),
                    ),
                  );
                } else {
                  Toaster.instance.toast(content: "Please Enter Name");
                }
              },
              icon: Icon(Icons.add),
              label: Text('Sign up'),
            ),
          );
        },
      ),
    );
  }

  Widget _body(final SignUpState state) {
    if (state is SignUpLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: ListTile(
          title: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'e.g. Ashwin Goyal',
            ),
            autofocus: true,
          ),
        ),
      );
    }
  }
}
