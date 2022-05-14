// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductHistory _$ProductHistoryFromJson(Map<String, dynamic> json) =>
    ProductHistory(
      json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      (json['number'] as List<dynamic>).map((e) => e as int).toList(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$ProductHistoryToJson(ProductHistory instance) =>
    <String, dynamic>{
      'product': instance.product,
      'number': instance.number,
      'date': instance.date?.toIso8601String(),
    };
