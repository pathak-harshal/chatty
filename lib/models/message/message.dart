import 'package:chatty/models/group/group.dart';
import 'package:chatty/models/user/user.dart';
import 'package:chatty/services/null_checker.dart';
import 'package:chatty/extensions/string_extension.dart';
import 'package:equatable/equatable.dart';

class Message with EquatableMixin {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  User user;
  Group group;
  final String body;
  final bool deleted;
  final String scrubbedBody;
  final String userName;
  bool selected;

  Message({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.group,
    this.body,
    this.deleted,
    this.scrubbedBody,
    this.userName,
    this.selected = false,
  });

  static const String attributes = '''
    id
    created_at
    updated_at
    deleted
    scrubbed_body
    user_name
  ''';

  factory Message.fromJson(final Map<String, dynamic> json) {
    if (blank(json)) {
      return null;
    } else {
      return Message(
        id: json['id'],
        createdAt: (json['created_at'] as String).toDateTime(),
        updatedAt: (json['updated_at'] as String).toDateTime(),
        user: User.fromJson(json['user']),
        group: Group.fromJson(json['group']),
        body: json['body'],
        deleted: json['deleted'],
        scrubbedBody: json['scrubbed_body'],
        userName: json['user_name'],
      );
    }
  }

  static List<Message> listFromJson(final List<dynamic> jsons) {
    if (blank(jsons)) {
      return [];
    } else {
      return jsons.map<Message>((final dynamic json) {
        return Message.fromJson(json);
      }).toList();
    }
  }

  Map<String, dynamic> get toCreateJson {
    return {
      'user_id': user.id,
      'group_id': group.id,
      'body': body,
    };
  }

  @override
  List<Object> get props {
    return [id];
  }
}
