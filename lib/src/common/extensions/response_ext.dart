import 'dart:convert';

import 'package:shelf/shelf.dart';

extension ResponseX on Response {
  static Response jsonList(List obj, {int status = 200}) {
    return Response(status,
        body: jsonEncode(obj.map((e) => e.toJson()).toList()));
  }

  static Response json(dynamic obj, {int status = 200}) {
    return Response(status, body: jsonEncode(obj.toJson()));
  }

  static Response notFound(
      {int status = 404,
      Map<String, String> errors = const {'not_found': 'Item not found'}}) {
    return Response(status, body: jsonEncode({'errors': errors}));
  }

  static Response invalidRequest(
      {int status = 400,
      Map<String, String> errors = const {
        'invalid_request': 'Invalid Request'
      }}) {
    return Response(status, body: jsonEncode({'errors': errors}));
  }
}
