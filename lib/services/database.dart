import 'package:hasura_connect/hasura_connect.dart';
import 'package:meta/meta.dart';

class Database {
  static final Database instance = Database();

  Future<Map<String, dynamic>> query({
    @required final String doc,
    final Map<String, dynamic> variables,
  }) async {
    return (await _client.query(doc, variables: variables))['data'];
  }

  Future<Map<String, dynamic>> mutation({
    @required final String doc,
    final Map<String, dynamic> variables,
  }) async {
    return (await _client.mutation(doc, variables: variables))['data'];
  }

  Stream<Map<String, dynamic>> subscription({
    @required final String doc,
    final Map<String, dynamic> variables,
    @required final String key,
  }) {
    return _client
        .subscription(doc, variables: variables, key: key)
        .map<Map<String, dynamic>>(
      (final dynamic convert) {
        return convert['data'];
      },
    );
  }

  HasuraConnect get _client {
    return HasuraConnect(
      'https://chatty.rirev.com/v1/graphql',
    );
  }
}
