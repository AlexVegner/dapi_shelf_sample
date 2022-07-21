import 'dart:convert';

import 'package:dapi_shelf_sample/dapi_shelf_sample.dart';
import 'package:dapi_shelf_sample/src/common/middlewares/auth_middleware.dart';

Router appRouter() {
  final app = Router();
  final publicApi = Router();
  app.mount('/api/v1', publicApi);

  final api = Router();

  publicApi.mount('/', getIt<AuthController>().router);

  publicApi.mount(
      '/',
      Pipeline()
          .addMiddleware(getIt<AuthMiddleware>().middleware())
          .addHandler(api));

  api.mount('/', getIt<UserController>().router);
  api.mount('/', getIt<DraftController>().router);
  api.mount('/', getIt<EventController>().router);

  api.all(
      '/<ignore|.*>',
      (Request r) =>
          Response.notFound(jsonEncode({'message': 'Route not defined'})));

  app.mount('/assets/', StaticAssetsApi(path: 'public').router);

  app.all('/<name|.*>', fallback('public/index.html'));
  return app;
}
