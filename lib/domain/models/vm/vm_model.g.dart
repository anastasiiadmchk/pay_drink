// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmModel _$VmModelFromJson(Map<String, dynamic> json) => VmModel(
      json['id'] as String,
      json['address'] as String?,
      json['type'] as String?,
      (json['products'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VmModelToJson(VmModel instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'type': instance.type,
      'products': instance.products,
    };
