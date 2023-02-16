import 'package:dapi_shelf_sample/dapi_shelf_sample.dart';
import 'package:postgres_pool/postgres_pool.dart';

class PgClient {
  late final PgPool pool;

  PgClient() {
    final c = PgCredentials.fromEnv();

    final instanceConnectionName =
        Platform.environment['INSTANCE_CONNECTION_NAME'];
    log.info('___log_INSTANCE_CONNECTION_NAME: $instanceConnectionName');
    if (instanceConnectionName != null) {
      final unixSocketPath = '/cloudsql/$instanceConnectionName';
      final connectUrl =
          'postgres://${c.user}:${c.password}@unix($unixSocketPath)/${c.db}?parseTime=true&is-unix-socket=1';
      log.info('___log $connectUrl');
      pool = PgPool(
        PgEndpoint.parse(connectUrl),
        settings: PgPoolSettings()
          ..maxConnectionAge = Duration(hours: 1)
          ..concurrency = 4,
      );
      return;
    }

    pool = PgPool(
      PgEndpoint(
        host: c.host ?? 'localhost',
        port: c.port ?? 5432,
        database: c.db ?? 'daylog',
        username: c.user ?? 'postgres',
        password: c.password ?? 'postgres',
        requireSsl: c.ssl ?? false,
      ),
      settings: PgPoolSettings()
        ..maxConnectionAge = Duration(hours: 1)
        ..concurrency = 4,
    );
  }
}

class PgCredentials {
  String? user;
  String? password;
  String? host;
  int? port;
  String? db;
  bool? ssl;
  PgCredentials();

  factory PgCredentials.fromEnv() {
    final pgSsl = Platform.environment['POSTGRES_SSL'] == 'true';
    final pgUrl = Platform.environment['DATABASE_URL'];
    if (pgUrl?.isNotEmpty == true) {
      final uri = Uri.parse(pgUrl!);
      final userInfo = uri.userInfo.split(':');
      // final user = userInfo[0];
      // print('user: $user');
      // final password = userInfo[1];
      // print('password: $password');
      // final host = uri.host;
      // print('host: $host');
      // final port = uri.port;
      // print('port: $port');
      // final db = uri.path.split('/')[1];
      // print('db: $db');
      return PgCredentials()
        ..host = uri.host
        ..port = uri.port
        ..user = userInfo[0]
        ..password = userInfo[1]
        ..db = uri.path.split('/')[1]
        ..ssl = pgSsl;
    }
    final pgPort = Platform.environment['POSTGRES_PORT'];
    final pgUser = Platform.environment['POSTGRES_USER'];
    final pgPassword = Platform.environment['POSTGRES_PASSWORD'];
    final pgDb = Platform.environment['POSTGRES_DB'];
    final pgHost = Platform.environment['DB_HOST'];
    return PgCredentials()
      ..host = pgHost
      ..port = (pgPort != null ? int.parse(pgPort) : null)
      ..user = pgUser
      ..password = pgPassword
      ..db = pgDb
      ..ssl = pgSsl;
  }
}
