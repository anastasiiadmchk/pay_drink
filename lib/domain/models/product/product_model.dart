import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class Product {
  final String? id;
  final String? code;
  final String? name;
  @JsonKey(name: 'providerId')
  final String? provider;
  final double? price;

  Product(this.code, this.name, this.provider, this.id, this.price);
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
