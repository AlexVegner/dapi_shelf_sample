import 'package:dapi_shelf_sample/src/common/clients/pg/pg_table.dart';
import 'package:dapi_shelf_sample/src/common/clients/pg_client.dart';
import 'package:postgres_pool/postgres_pool.dart';

import '../models/user.dart';

class UserService with PgTable<User> {
  final PgClient pgClient;

  UserService(this.pgClient);

  Future<User?> byLogin(String login) async {
    final query = '''
SELECT $fieldsStr 
FROM $table
WHERE login = @login
    ''';
    final response = await p.mappedResultsQuery(
      query,
      substitutionValues: {'login': login},
    );
    if (response.isEmpty) {
      return null;
    }
    return fromTableRow(response.first);
  }

  @override
  PgPool get p => pgClient.pool;

  @override
  String get table => 'users';

  @override
  List<String> get fields => ['id', 'login', 'password'];

  @override
  User fromTableRow(Map<String, Map<String, dynamic>> row) {
    return User(
      id: row[table]?['id'],
      login: row[table]?["login"],
      password: row[table]?['password'],
    );
  }

  @override
  Map<String, dynamic> toTable(doc) {
    return {
      'id': doc.id,
      'login': doc.login,
      'password': doc.password,
    };
  }
}
