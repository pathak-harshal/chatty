import 'package:chatty/models/user/user.dart';

abstract class SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpLoaded extends SignUpState {
  final User user;

  SignUpLoaded({this.user});
}
