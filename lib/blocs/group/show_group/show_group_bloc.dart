import 'dart:async';

import 'package:chatty/blocs/group/show_group/show_group_event.dart';
import 'package:chatty/blocs/group/show_group/show_group_state.dart';
import 'package:chatty/models/group/group.dart';
import 'package:chatty/models/message/message.dart';
import 'package:chatty/models/message/message_repo.dart';
import 'package:chatty/models/participant/participant.dart';
import 'package:chatty/models/participant/participant_repo.dart';
import 'package:chatty/models/user/user.dart';
import 'package:chatty/services/clipboard.dart';
import 'package:chatty/services/storage.dart';
import 'package:chatty/services/toaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class ShowGroupBloc extends Bloc<ShowGroupEvent, ShowGroupState> {
  final Group group;

  ShowGroupBloc({
    @required final this.group,
  }) : super(ShowGroupLoading());

  final List<Message> messages = [];
  StreamSubscription<DateTime> subscription;

  @override
  Stream<ShowGroupState> mapEventToState(
    final ShowGroupEvent event,
  ) async* {
    if (event is LoadShowGroup) {
      yield ShowGroupLoading();

      if (group.participants.any((final Participant participant) {
        return participant.user.id == Storage.instance.userId;
      })) {
      } else {
        await ParticipantRepo.instance.createParticipant(
          participant: Participant(
            user: User(id: Storage.instance.userId),
            group: group,
          ),
        );
      }

      add(LoadMessages(since: group.createdAt));
    } else if (event is LoadMessages) {
      final List<Message> messages = await MessageRepo.instance.getMessages(
        group: group,
        since: event.since,
      );

      messages.forEach((final Message message) {
        if (this.messages.contains(message)) {
          this.messages[this.messages.indexOf(message)] = message;
        } else {
          this.messages.insert(0, message);
        }
      });

      subscription ??=
          MessageRepo.instance.getRemoteMaxima(group: group).listen((
        final DateTime remoteMaxima,
      ) {
        DateTime localMaxima = messages.fold<DateTime>(
          group.createdAt,
          (final DateTime previousValue, final Message message) {
            if (previousValue.isBefore(message.updatedAt)) {
              return message.updatedAt;
            } else {
              return previousValue;
            }
          },
        );

        if (localMaxima.isBefore(remoteMaxima)) {
          add(LoadMessages(since: localMaxima));
        }
      });

      yield ShowGroupLoaded();
    } else if (event is SelectMessage) {
      messages.firstWhere((final Message message) {
        return message == event.message;
      }).selected = true;

      yield ShowGroupLoaded();
    } else if (event is DeselectMessage) {
      selectedMessages.firstWhere((final Message message) {
        return message == event.message;
      }).selected = false;

      yield ShowGroupLoaded();
    } else if (event is CopyMessages) {
      Clipboard.instance.copy(
        content: copyableMessages
            .map((final Message message) {
              return [
                message.userName,
                message.scrubbedBody,
              ].join(': ');
            })
            .toList()
            .join('\n'),
      );

      if (copyableMessages.length == 1) {
        Toaster.instance.toast(
          content: 'Message copied',
        );
      } else {
        Toaster.instance.toast(
          content: '${copyableMessages.length} messages copied',
        );
      }

      add(DeselectMessages());
    } else if (event is ArchiveMessages) {
      await MessageRepo.instance.archiveMessages(messages: archivableMessages);

      if (archivableMessages.length == 1) {
        Toaster.instance.toast(
          content: 'Message deleted',
        );
      } else {
        Toaster.instance.toast(
          content: '${archivableMessages.length} messages deleted',
        );
      }

      add(DeselectMessages());
    } else if (event is DeselectMessages) {
      selectedMessages.forEach((final Message message) {
        message.selected = false;
      });

      yield ShowGroupLoaded();
    } else if (event is CreateMessage) {
      messages.insert(
        0,
        await MessageRepo.instance.createMessage(
          message: event.message
            ..group = group
            ..user = User(id: Storage.instance.userId),
        ),
      );

      yield ShowGroupLoaded();
    }
  }

  List<Message> get selectedMessages {
    return messages.where((final Message message) {
      return message.selected == true;
    }).toList();
  }

  List<Message> get copyableMessages {
    final List<Message> copyableMessages = selectedMessages.where((
      final Message message,
    ) {
      return message.deleted == false;
    }).toList();

    if (copyableMessages.length == selectedMessages.length) {
      return copyableMessages;
    } else {
      return [];
    }
  }

  List<Message> get archivableMessages {
    final List<Message> archivableMessages = selectedMessages.where((
      final Message message,
    ) {
      return message.deleted == false;
    }).toList();

    if (archivableMessages.length == selectedMessages.length) {
      return archivableMessages;
    } else {
      return [];
    }
  }

  @override
  Future<void> close() async {
    await subscription.cancel();

    return super.close();
  }
}
