import 'package:dapi_shelf_sample/src/common/clients/pg/pg_table_with_uid.dart';
import 'package:dapi_shelf_sample/src/common/clients/pg_client.dart';
import 'package:dapi_shelf_sample/src/models/draft.dart';
import 'package:postgres_pool/postgres_pool.dart';

class DraftService with PgTableWithUid<Draft> {
  final PgClient pgClient;

  DraftService(this.pgClient);

  @override
  PgPool get p => pgClient.pool;

  @override
  String get table => 'drafts';

  @override
  List<String> get fields => [
        'id',
        'user_id',
        'start_date',
        'end_date',
        'start_at',
        'duration',
        'days',
        'title',
        'detail'
      ];

  @override
  Draft fromTableRow(Map<String, Map<String, dynamic>> row) {
    return Draft(
      id: row[table]?['id'],
      userId: row[table]?["user_id"],
      startDate: row[table]?['start_date'],
      endDate: row[table]?['end_date'],
      startAt: row[table]?['start_at'],
      duration: row[table]?['duration'],
      days: row[table]?['days'],
      title: row[table]?['title'],
      detail: row[table]?['detail'],
    );
  }

  @override
  Map<String, dynamic> toTable(doc) {
    return {
      'id': doc.id,
      'user_id': doc.userId,
      'start_date': doc.startDate,
      'end_date': doc.endDate,
      'start_at': doc.startAt,
      'duration': doc.duration,
      'days': doc.days,
      'title': doc.title,
      'detail': doc.detail,
    };
  }
}
