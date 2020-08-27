import 'package:chatty/services/null_checker.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static final Storage instance = Storage();
  SharedPreferences _sharedPreferences;

  Future<void> load() async {
    return _sharedPreferences = await SharedPreferences.getInstance();
  }

  String get userId {
    return _getString(key: 'user_id');
  }

  set userId(final String userId) {
    return _setString(key: 'user_id', value: userId);
  }

  String _getString({
    @required final String key,
  }) {
    return _sharedPreferences.getString(key);
  }

  void _setString({
    @required final String key,
    @required final String value,
  }) {
    if (blank(value)) {
      _sharedPreferences.remove(key);
    } else {
      _sharedPreferences.setString(key, value);
    }
  }
}
