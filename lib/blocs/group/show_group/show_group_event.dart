import 'package:chatty/models/message/message.dart';
import 'package:meta/meta.dart';

abstract class ShowGroupEvent {}

class LoadShowGroup extends ShowGroupEvent {}

class LoadMessages extends ShowGroupEvent {
  final DateTime since;

  LoadMessages({
    @required final this.since,
  });
}

class SelectMessage extends ShowGroupEvent {
  final Message message;

  SelectMessage({
    @required final this.message,
  });
}

class DeselectMessage extends ShowGroupEvent {
  final Message message;

  DeselectMessage({
    @required final this.message,
  });
}

class CopyMessages extends ShowGroupEvent {}

class ArchiveMessages extends ShowGroupEvent {}

class DeselectMessages extends ShowGroupEvent {}

class CreateMessage extends ShowGroupEvent {
  final Message message;

  CreateMessage({
    @required final this.message,
  });
}
