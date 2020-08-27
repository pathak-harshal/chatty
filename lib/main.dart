import 'package:bot_toast/bot_toast.dart';
import 'package:chatty/screens/group/group_screen.dart';
import 'package:chatty/screens/sign_up/sign_up_screen.dart';
import 'package:chatty/services/null_checker.dart';
import 'package:chatty/services/storage.dart';
import 'package:chatty/services/wayfinder.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Chatty());
}

class Chatty extends StatefulWidget {
  @override
  _ChattyState createState() {
    return _ChattyState();
  }
}

class _ChattyState extends State<Chatty> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  Future _loadPreferencesFuture;

  @override
  void initState() {
    _loadPreferencesFuture = Storage.instance.load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadPreferencesFuture,
      builder: (
        final BuildContext context,
        final AsyncSnapshot<dynamic> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return GestureDetector(
            child: MaterialApp(
              navigatorKey: _navigatorKey,
              title: 'Chatty',
              home: home(),
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              debugShowCheckedModeBanner: false,
            ),
            onTap: () {
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
            },
          );
        }
      },
    );
  }

  Widget home() {
    Wayfinder.instance.navigatorKey = _navigatorKey;

    if (blank(Storage.instance.userId)) {
      return SignUpScreen();
    } else {
      return GroupScreen();
    }
  }
}
