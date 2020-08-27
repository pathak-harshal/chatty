import 'package:clipboard/clipboard.dart';
import 'package:meta/meta.dart';

class Clipboard {
  static final Clipboard instance = Clipboard();

  void copy({
    @required final String content,
  }) {
    FlutterClipboard.copy(content);
  }
}
