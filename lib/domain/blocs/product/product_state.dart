class ProductState {
  final bool isLoadingPayment;
  final bool topicIsPublished;

//   final Map<VmModel, List<ProductHistory?>?>? deviceProductsHistory;
  const ProductState({
    this.isLoadingPayment = false,
    this.topicIsPublished = false,
  });

  ProductState copyWith({
    bool? isLoadingPayment,
    bool? topicIsPublished,
  }) {
    return ProductState(
      isLoadingPayment: isLoadingPayment ?? this.isLoadingPayment,
      topicIsPublished: topicIsPublished ?? this.topicIsPublished,
    );
  }
}

class PaymentSuccess extends ProductState {}

class ProductPayFailure extends ProductFailure {}

class ProductFailure extends ProductState {
  final String? error;
  ProductFailure({this.error});
}
