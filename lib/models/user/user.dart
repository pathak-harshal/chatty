import 'package:chatty/services/null_checker.dart';
import 'package:equatable/equatable.dart';

class User with EquatableMixin {
  final String id;
  final String name;

  User({
    this.id,
    this.name,
  });

  static const String attributes = '''
    id
    name
  ''';

  factory User.fromJson(final Map<String, dynamic> json) {
    if (blank(json)) {
      return null;
    } else {
      return User(
        id: json['id'],
        name: json['name'],
      );
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
