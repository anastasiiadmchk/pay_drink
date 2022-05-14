import 'package:json_annotation/json_annotation.dart';
import 'package:pay_drink/domain/models/product/product_model.dart';

part 'product_history_model.g.dart';

@JsonSerializable()
class ProductHistory {
  final Product? product;
  final List<int> number;
  final DateTime? date;

  ProductHistory(this.product, this.number, {this.date});
  factory ProductHistory.fromJson(Map<String, dynamic> json) =>
      _$ProductHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$ProductHistoryToJson(this);
}
