import 'package:json_annotation/json_annotation.dart';
import 'package:pay_drink/domain/models/product/product_model.dart';

part 'category_model.g.dart';

@JsonSerializable()
class Category {
  final String? category;
  @JsonKey(name: 'category_products')
  final List<String>? categoryProductsIds;

  final List<Product>? categoryProducts;

  Category(this.category, this.categoryProducts, this.categoryProductsIds);

  Category copyWith({String? category, List<Product>? categoryProducts}) {
    return Category(category ?? this.category,
        categoryProducts ?? this.categoryProducts, categoryProductsIds);
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
