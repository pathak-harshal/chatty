import 'package:chatty/models/group/group.dart';
import 'package:chatty/screens/group/group_screen.dart';
import 'package:chatty/screens/group/new_group/new_group_screen.dart';
import 'package:chatty/screens/group/show_group/show_group_screen.dart';
import 'package:chatty/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';

class Wayfinder {
  static final Wayfinder instance = Wayfinder();
  GlobalKey<NavigatorState> _navigatorKey;

  set navigatorKey(final GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  void pop() {
    _navigatorKey.currentState.pop();
  }

  void popUntilFirst() {
    _navigatorKey.currentState.popUntil((final Route route) {
      return route.isFirst;
    });
  }

  void popUntil({
    @required final String routeName,
  }) {
    _navigatorKey.currentState.popUntil(
      (final Route route) {
        return route.settings.name == routeName;
      },
    );
  }

  void signUp() {
    _replace(
      materialPageRoute: MaterialPageRoute(
        builder: (final BuildContext context) {
          return SignUpScreen();
        },
      ),
    );
  }

  void group() {
    _replace(
      materialPageRoute: MaterialPageRoute(
        builder: (context) {
          return GroupScreen();
        },
      ),
    );
  }

  void newGroup() {
    _push(
      materialPageRoute: MaterialPageRoute(
        builder: (context) {
          return NewGroupScreen();
        },
      ),
    );
  }

  void showGroup({
    @required final Group group,
  }) {
    _push(
      materialPageRoute: MaterialPageRoute(
        builder: (context) {
          return ShowGroupScreen(
            group: group,
          );
        },
      ),
    );
  }

  void _push({
    @required final MaterialPageRoute materialPageRoute,
  }) {
    _navigatorKey.currentState.push(materialPageRoute);
  }

  void _replace({
    @required final MaterialPageRoute materialPageRoute,
  }) {
    _navigatorKey.currentState.pushAndRemoveUntil(
      materialPageRoute,
      (final Route<dynamic> route) {
        return false;
      },
    );
  }
}
