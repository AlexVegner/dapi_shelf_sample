import 'package:postgres_pool/postgres_pool.dart';

abstract class PgTableWithUid<T> {
  PgPool get p;
  String get table;
  List<String> get fields;

  Map<String, dynamic> toTable(T doc);

  T fromTableRow(Map<String, Map<String, dynamic>> row);

  List<T> fromTableList(List<Map<String, Map<String, dynamic>>> result) {
    return result.map((e) => fromTableRow(e)).toList();
  }

  Future<List<T>> list({required String uid}) async {
    final query = 'SELECT $fieldsStr FROM $table WHERE user_id =@user_id';
    final response = await p.mappedResultsQuery(
      query,
      substitutionValues: {'user_id': uid},
    );
    return fromTableList(response);
  }

  Future<T?> byId(String id, {required String uid}) async {
    final query = '''
SELECT $fieldsStr 
FROM $table
WHERE id = @id AND user_id = @user_id
    ''';
    final response = await p.mappedResultsQuery(
      query,
      substitutionValues: {'id': id, 'user_id': uid},
    );
    if (response.isEmpty) {
      return null;
    }
    return fromTableRow(response.first);
  }

  Future<T> create(T doc) async {
    final query = '''
INSERT INTO $table ($fieldsCreate) 
VALUES ($createParams)
RETURNING $fieldsStr
''';
    final response = await p.mappedResultsQuery(
      query,
      substitutionValues: toTable(doc),
    );
    return fromTableRow(response.first);
  }

  Future<T?> update(T doc) async {
    final query = '''
UPDATE $table
SET $updateParams
WHERE id = @id AND user_id = @user_id
RETURNING $fieldsStr
''';
    final response = await p.mappedResultsQuery(
      query,
      substitutionValues: toTable(doc),
    );
    if (response.isEmpty) {
      return null;
    }
    return fromTableRow(response.first);
  }

  Future<int> delete(String id, {required String uid}) async {
    final query = '''
DELETE FROM $table
WHERE id = @id AND user_id = @user_id
''';
    final response = await p.execute(
      query,
      substitutionValues: {'id': id, 'user_id': uid},
    );
    return response;
  }

  String get fieldsStr => fields.map((e) => '$table.$e').join(', ');

  String get fieldsCreate => fields.where((e) => e != 'id').join(', ');

  String get createParams =>
      fields.where((e) => e != 'id').map((e) => '@$e').join(', ');

  String get updateParams => fields
      .where((e) => e != 'id' || e != 'user_id')
      .map((e) => '$e = @$e')
      .join(', ');
}
