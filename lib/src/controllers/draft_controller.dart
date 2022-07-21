import 'dart:convert';

import 'package:dapi_shelf_sample/dapi_shelf_sample.dart';
import 'package:dapi_shelf_sample/src/models/draft.dart';
import 'package:dapi_shelf_sample/src/services/draft_service.dart';

class DraftController {
  final DraftService draftService;

  DraftController({required this.draftService});

  Router get router {
    final router = Router();
    router.add('GET', '/drafts', list);
    router.add('GET', r'/drafts/<id>', byId);
    router.add('POST', '/drafts', create);
    router.add('PUT', r'/drafts/<id>', update);
    router.add('DELETE', r'/drafts/<id>', delete);
    return router;
  }

  Future<Response> list(Request request) async {
    final uid = request.uid!;
    final drafts = await draftService.list(uid: uid);
    return ResponseX.jsonList(drafts);
  }

  Future<Response> byId(Request request, String id) async {
    final uid = request.uid!;
    final draft = await draftService.byId(id, uid: uid);
    if (draft != null) {
      return ResponseX.json(draft);
    } else {
      return ResponseX.notFound();
    }
  }

  Future<Response> create(Request request) async {
    final uid = request.uid!;
    final body = await request.readAsString();
    final json = jsonDecode(body);
    json['userId'] = uid;
    final newDraft = Draft.fromJson(json);
    final createdDraft = await draftService.create(newDraft);
    return ResponseX.json(createdDraft);
  }

  Future<Response> update(Request request, String id) async {
    final uid = request.uid!;
    final body = await request.readAsString();
    final json = jsonDecode(body);
    json['id'] = id;
    json['userId'] = uid;
    final newDraft = Draft.fromJson(json);
    final updateDraft = await draftService.update(newDraft);
    if (updateDraft == null) {
      return ResponseX.notFound();
    }
    return ResponseX.json(updateDraft);
  }

  Future<Response> delete(Request request, String id) async {
    final uid = request.uid!;
    final result = await draftService.delete(id, uid: uid);
    if (result > 0) {
      return Response(204);
    }
    return ResponseX.notFound();
  }
}
