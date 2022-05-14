import 'package:pay_drink/domain/models/product_number/product_number_model.dart';

class ProductsState {
  final bool isLoading;
  final List<ProductNumber?>? productsNumber;
  const ProductsState({this.productsNumber, this.isLoading = false});

  ProductsState copyWith({
    bool? isLoading,
    List<ProductNumber?>? productsNumber,
  }) {
    return ProductsState(
      isLoading: isLoading ?? this.isLoading,
      productsNumber: productsNumber ?? this.productsNumber,
    );
  }
}

class VmProductsGetFailure extends VmFailure {}

class VmFailure extends ProductsState {
  final String? error;
  VmFailure({this.error});
}
