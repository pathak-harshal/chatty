import 'package:chatty/models/participant/participant.dart';
import 'package:chatty/services/null_checker.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:chatty/extensions/string_extension.dart';

class Group with EquatableMixin {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String preview;
  final List<Participant> participants;

  Group({
    this.id,
    this.createdAt,
    this.updatedAt,
    @required this.name,
    this.preview,
    this.participants,
  });

  static const String attributes = '''
    id
    created_at
    updated_at
    name
    preview
    participants {
      ${Participant.attributes}
    }
  ''';

  factory Group.fromJson(final Map<String, dynamic> json) {
    if (blank(json)) {
      return null;
    } else {
      return Group(
        id: json['id'],
        createdAt: (json['created_at'] as String).toDateTime(),
        updatedAt: (json['updated_at'] as String).toDateTime(),
        name: json['name'],
        preview: json['preview'],
        participants: Participant.listFromJson(json['participants']),
      );
    }
  }

  static List<Group> listFromJson(final List<dynamic> jsons) {
    if (blank(jsons)) {
      return [];
    } else {
      return jsons.map<Group>((final dynamic json) {
        return Group.fromJson(json);
      }).toList();
    }
  }

  Map<String, dynamic> get toCreateJson {
    return {
      'name': name,
    };
  }

  @override
  List<Object> get props {
    return [id];
  }
}
