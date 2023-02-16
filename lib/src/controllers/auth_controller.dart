import 'dart:convert';

import 'package:dapi_shelf_sample/src/common/extensions/response_ext.dart';
import 'package:dapi_shelf_sample/src/common/log.dart';
import 'package:dapi_shelf_sample/src/models/token.dart';
import 'package:dapi_shelf_sample/src/models/user.dart';
import 'package:dapi_shelf_sample/src/services/user_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthController {
  final UserService userService;

  AuthController({required this.userService});

  Router get router {
    final router = Router();
    router.add('POST', '/auth/login', login);
    router.add('POST', '/auth/signup', signup);
    return router;
  }

  Future<Response> login(Request request) async {
    final body = await request.readAsString();

    try {
      final json = jsonDecode(body);
      final user = User.fromJson(json);
      final dbuser = await userService.byLogin(user.login);
      if (dbuser?.id != null && user.password == dbuser?.password) {
        return ResponseX.json(Token.create(dbuser!.id!));
      } else {
        return Response(401);
      }
    } catch (e) {
      log.severe('__error__', e);
      return ResponseX.invalidRequest();
    }
  }

  Future<Response> signup(Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body);
      final newUser = User.fromJson(json);
      final createdUser = await userService.create(newUser);
      return Response.ok(jsonEncode(createdUser.toJsonWithoutPassword()));
    } catch (e) {
      log.severe('__error__', e);
      return ResponseX.invalidRequest();
    }
  }
}
