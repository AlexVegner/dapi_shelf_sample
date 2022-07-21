import 'package:dapi_shelf_sample/src/common/clients/pg_client.dart';
import 'package:dapi_shelf_sample/src/common/middlewares/auth_middleware.dart';
import 'package:dapi_shelf_sample/src/controllers/auth_controller.dart';
import 'package:dapi_shelf_sample/src/controllers/draft_controller.dart';
import 'package:dapi_shelf_sample/src/controllers/event_controller.dart';
import 'package:dapi_shelf_sample/src/controllers/user_controller.dart';
import 'package:dapi_shelf_sample/src/services/draft_service.dart';
import 'package:dapi_shelf_sample/src/services/event_service.dart';
import 'package:dapi_shelf_sample/src/services/user_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupInjections() async {
  // Firebase Storage.

  getIt.registerLazySingleton<PgClient>(
    () => PgClient(),
  );

  getIt.registerLazySingleton<AuthMiddleware>(
    () => AuthMiddleware(userService: getIt()),
  );

  getIt.registerLazySingleton<AuthController>(
    () => AuthController(userService: getIt()),
  );

  // User
  getIt.registerLazySingleton<UserService>(
    () => UserService(
      getIt(),
    ),
  );

  getIt.registerLazySingleton<UserController>(
    () => UserController(userService: getIt()),
  );

  // Draft

  getIt.registerLazySingleton<DraftService>(
    () => DraftService(
      getIt(),
    ),
  );

  getIt.registerLazySingleton<DraftController>(
    () => DraftController(draftService: getIt()),
  );

  // Event

  getIt.registerLazySingleton<EventService>(
    () => EventService(
      getIt(),
    ),
  );

  getIt.registerLazySingleton<EventController>(
    () => EventController(eventService: getIt()),
  );
}
