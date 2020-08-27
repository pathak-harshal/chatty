import 'package:chatty/models/group/group.dart';
import 'package:chatty/services/database.dart';
import 'package:chatty/services/storage.dart';
import 'package:meta/meta.dart';

class GroupRepo {
  static final GroupRepo instance = GroupRepo();

  Future<List<Group>> getGroups({
    @required final DateTime since,
  }) async {
    return Group.listFromJson(
      (await Database.instance.query(
        doc: '''
          query getGroups(\$since: timestamptz!) {
            groups(
              where: {
                updated_at: {_gte: \$since},
              }, 
              order_by: {
                updated_at: desc,
              },
            ) {
              ${Group.attributes}
            }
          }
        ''',
        variables: {
          'since': since.toUtc().toString(),
        },
      ))['groups'],
    );
  }

  Future<Group> createGroup({
    @required final Group group,
  }) async {
    return Group.fromJson(
      (await Database.instance.mutation(
        doc: '''
          mutation createGroup(
            \$insert_group: groups_insert_input!
          ) {
            insert_groups_one(object: \$insert_group) {
              ${Group.attributes}
            }
          }
        ''',
        variables: {
          'insert_group': group.toCreateJson,
        },
      ))['insert_groups_one'],
    );
  }

  Stream<DateTime> getRemoteMaxima() {
    return Database.instance.subscription(
      doc: '''
        subscription getPing {
          groups(
            order_by: {
              updated_at: desc,
            },
            limit: 1,
          ) {
            updated_at
          }
        }
      ''',
      key: Storage.instance.userId,
    ).map<DateTime>((Map<String, dynamic> convert) {
      return Group.listFromJson(convert['groups']).fold<DateTime>(
        DateTime(2020, 1, 1),
        (final DateTime previousValue, final Group group) {
          if (previousValue.isBefore(group.updatedAt)) {
            return group.updatedAt;
          } else {
            return previousValue;
          }
        },
      );
    });
  }
}
