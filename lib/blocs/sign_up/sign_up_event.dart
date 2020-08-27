import 'package:chatty/models/user/user.dart';
import 'package:meta/meta.dart';

abstract class SignUpEvent {}

class LoadSignUp extends SignUpEvent {}

class CreateUser extends SignUpEvent {
  final User user;

  CreateUser({
    @required final this.user,
  });
}
