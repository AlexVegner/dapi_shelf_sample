import 'package:dapi_shelf_sample/src/common/clients/pg/pg_table_with_uid.dart';
import 'package:dapi_shelf_sample/src/common/clients/pg_client.dart';
import 'package:dapi_shelf_sample/src/models/event.dart';
import 'package:postgres_pool/postgres_pool.dart';

class EventService with PgTableWithUid<Event> {
  final PgClient pgClient;

  EventService(this.pgClient);

  Future<List<Event>> listWithDate(
      {required String uid, required String date}) async {
    final query =
        'SELECT $fieldsStr FROM $table WHERE user_id = @user_id AND start_date = @start_date';
    final response = await p.mappedResultsQuery(
      query,
      substitutionValues: {'user_id': uid, 'start_date': date},
    );
    return fromTableList(response);
  }

  @override
  PgPool get p => pgClient.pool;

  @override
  String get table => 'events';

  @override
  List<String> get fields => [
        'id',
        'user_id',
        'draft_id',
        // 'update_at',
        'start_at',
        'start_date',
        'duration',
        'status',
        'title',
        'detail',
        'comment',
      ];

  @override
  Event fromTableRow(Map<String, Map<String, dynamic>> row) {
    return Event(
      id: row[table]?['id'],
      userId: row[table]?["user_id"],
      draftId: row[table]?["draft_id"],
      // updateAt: row[table]?['update_at'],
      startAt: row[table]?['start_at'],
      startDate: row[table]?['start_date'],
      duration: row[table]?['duration'],
      status: EventStatus.parse(row[table]?['status']),
      title: row[table]?['title'],
      detail: row[table]?['detail'],
    );
  }

  @override
  Map<String, dynamic> toTable(doc) {
    return {
      'id': doc.id,
      'user_id': doc.userId,
      'draft_id': doc.draftId,
      // 'update_at': doc.updateAt,
      'start_at': doc.startAt,
      'start_date': doc.startDate,
      'duration': doc.duration,
      'status': doc.status?.name,
      'title': doc.title,
      'detail': doc.detail,
      'comment': doc.comment,
    };
  }
}
