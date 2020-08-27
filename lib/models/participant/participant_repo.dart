import 'package:chatty/models/participant/participant.dart';
import 'package:chatty/services/database.dart';
import 'package:meta/meta.dart';

class ParticipantRepo {
  static final ParticipantRepo instance = ParticipantRepo();

  Future<Participant> createParticipant({
    @required final Participant participant,
  }) async {
    return Participant.fromJson(
      (await Database.instance.mutation(
        doc: '''
          mutation createParticipant(
            \$insert_participant: participants_insert_input!
          ) {
            insert_participants_one(object: \$insert_participant) {
              ${Participant.attributes}
            }
          }
        ''',
        variables: {
          'insert_participant': participant.toCreateJson,
        },
      ))['insert_participants_one'],
    );
  }
}
