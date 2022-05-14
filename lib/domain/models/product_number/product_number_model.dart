import 'package:json_annotation/json_annotation.dart';
import 'package:pay_drink/domain/models/product/product_model.dart';

part 'product_number_model.g.dart';

@JsonSerializable()
class ProductNumber {
  final Product? product;
  final int? number;

  ProductNumber(this.product, this.number);
  factory ProductNumber.fromJson(Map<String, dynamic> json) =>
      _$ProductNumberFromJson(json);

  Map<String, dynamic> toJson() => _$ProductNumberToJson(this);
}
