import 'package:shelf/shelf.dart';

extension RequestExt on Request {
  String? get uid => context['uid'] as String?;
}
