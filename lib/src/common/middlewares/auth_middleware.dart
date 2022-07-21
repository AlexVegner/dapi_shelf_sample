import 'package:dapi_shelf_sample/dapi_shelf_sample.dart';
import 'package:dapi_shelf_sample/src/common/constants.dart';
import 'package:dapi_shelf_sample/src/models/token.dart';
import 'package:dapi_shelf_sample/src/services/user_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthMiddleware {
  final UserService userService;
  AuthMiddleware({required this.userService});

  Middleware middleware() => (next) {
        return (request) async {
          final authorizationHeader = request.headers['Authorization'] ??
              request.headers['authorization'];

          if (authorizationHeader == null) {
            return Response(401);
          }

          if (!authorizationHeader.startsWith('Bearer ')) {
            return Response(401);
          }

          final token = authorizationHeader.replaceFirst('Bearer ', '').trim();
          if (Constants.debug) {
            if (token.startsWith('uid=')) {
              final uid = token.replaceFirst('uid=', '').trim();
              request =
                  request.change(context: {...request.context, 'uid': uid});
              return next(request);
            } else if (token.startsWith('login=')) {
              final login = token.replaceFirst('login=', '').trim();
              try {
                final user = await userService.byLogin(login);
                if (user != null) {
                  request = request
                      .change(context: {...request.context, 'uid': user.id});
                  return next(request);
                }
              } catch (e) {
                log.severe(e);
              }
            }
          }

          try {
            // Verify a token
            final uid = Token(token).uid();
            request = request.change(context: {...request.context, 'uid': uid});
            return next(request);
          } on JWTExpiredError {
            print('jwt expired');
            return Response(401, body: 'jwt expired');
          } on JWTError catch (ex) {
            print(ex);
            return Response(401);
          } catch (e) {
            print(e);
            return Response(401);
          }
        };
      };
}
