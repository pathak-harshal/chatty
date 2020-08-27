import 'package:chatty/blocs/sign_up/sign_up_event.dart';
import 'package:chatty/blocs/sign_up/sign_up_state.dart';
import 'package:chatty/models/user/user.dart';
import 'package:chatty/models/user/user_repo.dart';
import 'package:chatty/services/storage.dart';
import 'package:chatty/services/wayfinder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpLoading());

  @override
  Stream<SignUpState> mapEventToState(
    final SignUpEvent event,
  ) async* {
    if (event is LoadSignUp) {
      yield SignUpLoading();

      yield SignUpLoaded();
    } else if (event is CreateUser) {
      yield SignUpLoading();

      final User user = await UserRepo.instance.createUser(user: event.user);
      Storage.instance.userId = user.id;

      Wayfinder.instance.group();
    }
  }
}
