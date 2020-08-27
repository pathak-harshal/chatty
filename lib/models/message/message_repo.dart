import 'package:chatty/models/group/group.dart';
import 'package:chatty/models/message/message.dart';
import 'package:chatty/services/database.dart';
import 'package:meta/meta.dart';

class MessageRepo {
  static final MessageRepo instance = MessageRepo();

  Future<List<Message>> getMessages({
    @required final Group group,
    @required final DateTime since,
  }) async {
    return Message.listFromJson(
      (await Database.instance.query(
        doc: '''
          query getMessages(
            \$group_id: uuid!,
            \$since: timestamptz!
          ) {
            messages(
              where: {
                group: {
                  id: {_eq: \$group_id},
                },
                updated_at: {_gte: \$since},
              }, 
              order_by: {
                created_at: asc,
              },
            ) {
              ${Message.attributes}
            }
          }
        ''',
        variables: {
          'group_id': group.id,
          'since': since.toUtc().toString(),
        },
      ))['messages'],
    );
  }

  Stream<DateTime> getRemoteMaxima({
    @required final Group group,
  }) {
    return Database.instance.subscription(
      doc: '''
        subscription getPing(
          \$group_id: uuid!,
        ) {
          messages(
            where: {
              group: {
                id: {_eq: \$group_id},
              },
            }, 
            order_by: {
              updated_at: desc,
            },
            limit: 1,
          ) {
            updated_at
          }
        }
      ''',
      variables: {
        'group_id': group.id,
      },
      key: group.id,
    ).map<DateTime>((Map<String, dynamic> convert) {
      return Message.listFromJson(convert['messages']).fold<DateTime>(
        group.createdAt,
        (final DateTime previousValue, final Message message) {
          if (previousValue.isBefore(message.updatedAt)) {
            return message.updatedAt;
          } else {
            return previousValue;
          }
        },
      );
    });
  }

  Future<Message> createMessage({
    @required final Message message,
  }) async {
    return Message.fromJson(
      (await Database.instance.mutation(
        doc: '''
          mutation createMessage(
            \$insert_message: messages_insert_input!
          ) {
            insert_messages_one(object: \$insert_message) {
              ${Message.attributes}
            }
          }
        ''',
        variables: {
          'insert_message': message.toCreateJson,
        },
      ))['insert_messages_one'],
    );
  }

  Future<int> archiveMessages({
    @required final List<Message> messages,
  }) async {
    return (await Database.instance.mutation(
      doc: '''
        mutation archiveMessage(
          \$archive_message_ids: [uuid!]!
        ) {
          update_messages(
            where: {
              id: {_in: \$archive_message_ids}
            }, 
            _set: {
              archived_at: "now()",
            }
          ) {
            affected_rows
          }
        }
      ''',
      variables: {
        'archive_message_ids': messages.map<String>((
          final Message message,
        ) {
          return message.id;
        }).toList(),
      },
    ))['update_messages']['affected_rows'];
  }
}
