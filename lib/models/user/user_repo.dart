import 'package:chatty/models/user/user.dart';
import 'package:chatty/services/database.dart';
import 'package:meta/meta.dart';

class UserRepo {
  static final UserRepo instance = UserRepo();

  Future<User> getUser({
    @required final String userId,
  }) async {
    return User.fromJson(
      (await Database.instance.query(
        doc: '''
          query getUser(
            \$user_id: uuid!,
          ) {
            users_by_pk(id: \$user_id) {
              ${User.attributes}
            }
          }
        ''',
        variables: {
          'user_id': userId,
        },
      ))['users_by_pk'],
    );
  }

  Future<User> createUser({
    @required final User user,
  }) async {
    return User.fromJson(
      (await Database.instance.mutation(
        doc: '''
          mutation createUser(
            \$insert_user: users_insert_input!
          ) {
            insert_users_one(object: \$insert_user) {
              ${User.attributes}
            }
          }
        ''',
        variables: {
          'insert_user': user.toCreateJson,
        },
      ))['insert_users_one'],
    );
  }
}
