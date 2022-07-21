import 'package:dapi_shelf_sample/src/common/utils/date_utils.dart';

class Draft {
  final String? id;
  final String? userId;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? startAt;
  final int? duration;
  final int? days; // 1000011 => 64 + 3 = 67
  final String? title;
  final String? detail;

  Draft({
    this.id,
    this.userId,
    this.startDate,
    this.endDate,
    this.startAt,
    this.duration,
    this.days,
    this.title,
    this.detail,
  });

  Draft.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        startDate = DateTime.parse(json['startDate']),
        endDate = DateTime.parse(json['endDate']),
        startAt = DateTime.parse(json['startAt']),
        duration = json['duration'],
        days = json['days'],
        title = json['title'],
        detail = json['detail'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'startDate': startDate?.formatDate(),
        'endDate': endDate?.formatDate(),
        'startAt': startAt?.formatDateTime(),
        'duration': duration,
        'days': days,
        'title': title,
        'detail': detail,
      };
}
