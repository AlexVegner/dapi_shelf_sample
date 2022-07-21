import 'dart:convert';

import 'package:dapi_shelf_sample/dapi_shelf_sample.dart';
import 'package:dapi_shelf_sample/src/models/event.dart';
import 'package:dapi_shelf_sample/src/services/event_service.dart';

class EventController {
  final EventService eventService;

  EventController({required this.eventService});

  Router get router {
    final router = Router();
    router.add('GET', '/events', list);
    router.add('GET', r'/events/<id>', byId);
    router.add('POST', '/events', create);
    router.add('PUT', r'/events/<id>', update);
    router.add('DELETE', r'/events/<id>', delete);
    return router;
  }

  Future<Response> list(Request request) async {
    final date = request.url.queryParameters['date'];
    final uid = request.uid!;
    if (date != null) {
      final docs = await eventService.listWithDate(uid: uid, date: date);
      return ResponseX.jsonList(docs);
    }
    final docs = await eventService.list(uid: uid);
    return ResponseX.jsonList(docs);
  }

  Future<Response> byId(Request request, String id) async {
    final uid = request.uid!;
    final event = await eventService.byId(id, uid: uid);
    if (event != null) {
      return ResponseX.json(event);
    } else {
      return ResponseX.notFound();
    }
  }

  Future<Response> create(Request request) async {
    final uid = request.uid!;
    final body = await request.readAsString();
    final json = jsonDecode(body);
    json['userId'] = uid;
    final newEvent = Event.fromJson(json);
    final createdEvent = await eventService.create(newEvent);
    return ResponseX.json(createdEvent);
  }

  Future<Response> update(Request request, String id) async {
    final uid = request.uid!;
    final body = await request.readAsString();
    final json = jsonDecode(body);
    json['id'] = id;
    json['userId'] = uid;
    final newEvent = Event.fromJson(json);
    final updatedEvent = await eventService.update(newEvent);
    if (updatedEvent == null) {
      return ResponseX.notFound();
    }
    return ResponseX.json(updatedEvent);
  }

  Future<Response> delete(Request request, String id) async {
    final uid = request.uid!;
    final result = await eventService.delete(id, uid: uid);
    if (result > 0) {
      return Response(204);
    }
    return ResponseX.notFound();
  }
}
