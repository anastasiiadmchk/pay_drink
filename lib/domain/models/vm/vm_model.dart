import 'package:json_annotation/json_annotation.dart';
import 'package:pay_drink/domain/models/product_category/category_model.dart';

part 'vm_model.g.dart';

@JsonSerializable()
class VmModel {
  final String id;
  final String? address;
  final String? type;

  final List<Category>? products;

  VmModel(this.id, this.address, this.type, this.products);
  factory VmModel.fromJson(Map<String, dynamic> json) =>
      _$VmModelFromJson(json);

  Map<String, dynamic> toJson() => _$VmModelToJson(this);

  VmModel copyWith({List<Category>? products}) {
    return VmModel(id, address, type, products ?? this.products);
  }
}
