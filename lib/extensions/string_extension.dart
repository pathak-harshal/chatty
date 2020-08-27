import 'package:chatty/services/null_checker.dart';

extension StringExtension on String {
  DateTime toDateTime() {
    if (blank(this)) {
      return null;
    } else {
      return DateTime.parse(this);
    }
  }
}
