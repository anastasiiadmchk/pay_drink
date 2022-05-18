import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/data/mqtt.dart';
import 'package:pay_drink/domain/blocs/product/product_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class ProductCubit extends Cubit<ProductState> {
  // ProductCubit({required VmStatisticRepo productRepo})
//       : super(const ProductState(isLoading: false)) {
//     _productRepo = productRepo;
  ProductCubit() : super(const ProductState());

//   late final VmStatisticRepo _productRepo;

  Future<void> makePayment(
      {required String deviceId,
      required String productInfo,
      required String productsNumber}) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoadingPayment: true));

      //Check payment

      deviceId = 'kyiv_city/' + deviceId + '/beverages';
      //Publish topic
      final _mqttData = BehaviorSubject();

      Mqtt _mqtt = Mqtt(
        uuid: const Uuid().v4().toString().substring(0, 10),
        deviceId: deviceId,
        productId: productInfo,
      );

      await _mqtt.connect()?.pipe(_mqttData.sink);

      _mqttData.stream.listen((d) {
        print('device_widget_conection');
      });
      _mqtt.publishMessage(productsNumber);

      Future.delayed(const Duration(seconds: 2), () {
        emit(state.copyWith(isLoadingPayment: false, topicIsPublished: true));
        emit(PaymentSuccess());
      });
    } catch (e) {
      emit(ProductPayFailure());
      emit(stableState.copyWith(isLoadingPayment: false));
    }
  }

//   Future<void> getAllProductsHistory({required List<VmModel> vmModels}) async {
//     final stableState = state;
//     try {
//       emit(state.copyWith(isLoading: true));
//       Map<VmModel, List<ProductHistory?>?>? deviceProductsHistory = {};
//       for (final element in vmModels) {
//         final list = await _productRepo.getProductsHistory(vmModel: element);
//         deviceProductsHistory[element] = list;
//       }

//       emit(state.copyWith(
//           deviceProductsHistory: deviceProductsHistory, isLoading: false));
//     } catch (e) {
//       emit(ProductsHistoryGetFailure());
//       emit(stableState.copyWith(isLoading: false));
//     }
//   }

}
