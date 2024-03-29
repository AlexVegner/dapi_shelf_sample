// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

const ORIGIN = 'origin';
const ALLOW_ORIGIN = 'allow_origin';

Middleware handleCors({List<String>? origins}) => (Handler next) {
      return (request) async {
        final origin = _getAllowOrigin(origins, request.headers[ORIGIN]);
        if (origin != null) {
          if (request.method == 'OPTIONS') {
            return Response.ok('', headers: _modifyCorsHeaders(origin: origin));
          }
        }
        var response = await next(request);
        if (origin != null) {
          return response.change(
            headers: _modifyCorsHeaders(
              headers: response.headers,
              origin: origin,
            ),
          );
        }
        return response;
      };
    };

String generateSalt([int length = 32]) {
  final rand = Random.secure();
  final saltBytes = List<int>.generate(length, (_) => rand.nextInt(256));
  return base64.encode(saltBytes);
}

String hashPassword(String password, String salt) {
  final codec = Utf8Codec();
  final key = codec.encode(password);
  final saltBytes = codec.encode(salt);
  final hmac = Hmac(sha256, key);
  final digest = hmac.convert(saltBytes);
  return digest.toString();
}

String generateJwt(
  String subject,
  String issuer,
  String secret, {
  String? jwtId,
  Duration expiry = const Duration(seconds: 30),
}) {
  final jwt = JWT(
    {
      'iat': DateTime.now().millisecondsSinceEpoch,
    },
    subject: subject,
    issuer: issuer,
    jwtId: jwtId,
  );
  return jwt.sign(SecretKey(secret), expiresIn: expiry);
}

Middleware handleAuth(String secret) {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['authorization'];
      JWT? jwt;

      try {
        if (authHeader != null && authHeader.startsWith('Bearer ')) {
          final token = authHeader.substring(7);
          jwt = JWT.verify(token, SecretKey(secret));
        }
      } catch (_) {}

      final updatedRequest = request.change(context: {
        'authDetails': jwt,
      });
      return await innerHandler(updatedRequest);
    };
  };
}

Middleware checkAuthorisation() {
  return createMiddleware(
    requestHandler: (Request request) {
      if (request.context['authDetails'] == null) {
        return Response.forbidden('Not authorised to perform this action.');
      }
      return null;
    },
  );
}

Handler fallback(String indexPath) => (Request request) {
      final indexFile = File(indexPath).readAsStringSync();
      return Response.ok(indexFile, headers: {'content-type': 'text/html'});
    };

Map<String, Object> _modifyCorsHeaders({
  Map<String, Object>? headers,
  required String origin,
}) {
  return {
    if (headers != null) ...headers,
    'Access-Control-Allow-Origin': origin,
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
    'Access-Control-Allow-Headers':
        'Origin, Content-Type, Accept, Authorization',
  };
}

String? _getAllowOrigin(List<String>? allowedOrigins, String? origin) {
  print(origin);
  if (allowedOrigins != null && allowedOrigins.contains(origin)) {
    return origin;
  }
  return null;
}
