import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class GeoPointConverter implements JsonConverter<GeoPoint?, dynamic> {
  const GeoPointConverter();

  @override
  GeoPoint? fromJson(dynamic json) {
    if (json is GeoPoint) {
      return json;
    } /* else if (json is List) {
      return GeoPoint(json[0], json[1]);
    } */
    return null;
  }

  @override
  GeoPoint? toJson(GeoPoint? object) {
    final latitude = object?.latitude;
    final longitude = object?.longitude;
    if (latitude == null || longitude == null) {
      return null;
    }
    return object;
  }
}
