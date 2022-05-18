import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampConverter();

  @override
  DateTime? fromJson(dynamic timestamp) {
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is Map<String, dynamic>) {
      if (timestamp.isNotEmpty && timestamp['_nanoseconds'] != null) {
        return Timestamp(timestamp['_seconds'], timestamp['_nanoseconds'])
            .toDate();
      } else {
        return DateTime.fromMillisecondsSinceEpoch(timestamp['_seconds']);
      }
    } else {
      return null;
    }
  }

  @override
  Timestamp? toJson(DateTime? date) {
    return date == null ? null : Timestamp.fromDate(date);
  }
}
