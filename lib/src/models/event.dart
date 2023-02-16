import 'package:dapi_shelf_sample/src/common/utils/date_utils.dart';

class Event {
  final String? id;
  final String? userId;
  final String? draftId;
  // final DateTime? updateAt;
  final DateTime? startAt;
  final DateTime? startDate;
  final int? duration;
  final EventStatus? status;
  final String? title;
  final String? detail;
  final String? comment;

  Event({
    this.id,
    this.userId,
    this.draftId,
    // this.updateAt,
    this.startAt,
    this.startDate,
    this.duration,
    this.status,
    this.title,
    this.detail,
    this.comment,
  });

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        draftId = json['draftId'],
        // updateAt = DateTime.parse(json['updateAt']),
        startAt = DateTime.parse(json['startAt']),
        startDate = DateTime.parse(json['startDate']),
        duration = json['duration'],
        status = EventStatus.parse(json['status']),
        title = json['title'],
        detail = json['detail'],
        comment = json['comment'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'draftId': draftId,
        // 'updateAt': updateAt?.formatDateTime(),
        'startAt': startAt?.formatDateTime(),
        'startDate': startDate?.formatDate(),
        'duration': duration,
        'status': status?.name,
        'title': title,
        'detail': detail,
        'comment': comment,
      };
}

enum EventStatus {
  todo,
  progress,
  done;

  static EventStatus parse(String? value) {
    return values.firstWhere((e) => e.name == value,
        orElse: () => EventStatus.todo);
  }
}

extension EventStatusX on EventStatus {}
