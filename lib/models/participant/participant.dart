import 'package:chatty/models/group/group.dart';
import 'package:chatty/models/user/user.dart';
import 'package:chatty/services/null_checker.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Participant with EquatableMixin {
  final User user;
  final Group group;

  Participant({
    @required this.user,
    this.group,
  });

  static const String attributes = '''
    user {
      id
    }
  ''';

  factory Participant.fromJson(final Map<String, dynamic> json) {
    if (blank(json)) {
      return null;
    } else {
      return Participant(
        user: User.fromJson(json['user']),
      );
    }
  }

  static List<Participant> listFromJson(final List<dynamic> jsons) {
    if (blank(jsons)) {
      return [];
    } else {
      return jsons.map<Participant>((final dynamic json) {
        return Participant.fromJson(json);
      }).toList();
    }
  }

  Map<String, dynamic> get toCreateJson {
    return {
      'user_id': user.id,
      'group_id': group.id,
    };
  }

  @override
  List<Object> get props {
    return [user];
  }
}
