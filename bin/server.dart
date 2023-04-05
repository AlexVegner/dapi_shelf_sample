import 'package:dapi_shelf_sample/dapi_shelf_sample.dart';

void main(List<String> arguments) async {
  setupInjections();
  setupLogger();
  final hostName = Platform.environment['HOST'] ?? InternetAddress.anyIPv4;
  final portStr = Platform.environment['PORT'];
  var port = portStr != null ? int.parse(portStr) : 8081;
  final router = appRouter();

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors(origins: ["http://localhost:8686"]))
      .addHandler(router);

  await serve(handler, hostName, port);

  print('HTTP Service running on port $port');
}
