// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_number_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductNumber _$ProductNumberFromJson(Map<String, dynamic> json) =>
    ProductNumber(
      json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      json['number'] as int?,
    );

Map<String, dynamic> _$ProductNumberToJson(ProductNumber instance) =>
    <String, dynamic>{
      'product': instance.product,
      'number': instance.number,
    };
