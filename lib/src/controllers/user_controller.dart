import 'dart:convert';

import 'package:dapi_shelf_sample/dapi_shelf_sample.dart';
import 'package:dapi_shelf_sample/src/services/user_service.dart';

class UserController {
  final UserService userService;

  UserController({required this.userService});

  Router get router {
    final router = Router();
    router.add('GET', '/me', me);
    router.add('PUT', '/me', update);
    router.add('DELETE', '/me', delete);
    return router;
  }

  Future<Response> me(Request request) async {
    try {
      final uid = request.uid!;
      final user = await userService.byId(uid);
      if (user != null) {
        return Response.ok(jsonEncode(user.toJsonWithoutPassword()));
      } else {
        return Response.notFound('no such user');
      }
    } catch (e) {
      log.severe('__error__', e);
      return ResponseX.invalidRequest();
    }
  }

  Future<Response> update(Request request) async {
    try {
      final uid = request.uid!;
      final body = await request.readAsString();
      final json = jsonDecode(body);
      json['id'] = uid;
      final newUser = User.fromJson(json);
      final updateUser = await userService.update(newUser);
      if (updateUser == null) {
        return ResponseX.notFound();
      }
      return Response.ok(jsonEncode(updateUser.toJsonWithoutPassword()));
    } catch (e) {
      log.severe('__error__', e);
      return ResponseX.invalidRequest();
    }
  }

  Future<Response> delete(Request request) async {
    try {
      final uid = request.uid!;
      final result = await userService.delete(uid);
      if (result > 0) {
        return Response(204);
      }
      return Response.notFound('');
    } catch (e) {
      log.severe('__error__', e);
      return ResponseX.invalidRequest();
    }
  }

  // Future<Response> getList(Request request) async {
  //   final users = await userService.list();
  //   return Response.ok(
  //       jsonEncode(users.map((e) => e.toJsonWithoutPassword()).toList()));
  // }

}
