import 'package:pay_drink/domain/models/product_number/product_number_model.dart';
import 'package:pay_drink/domain/models/vm/vm_model.dart';

abstract class RealDbRepo {
  Future<List<ProductNumber?>?> getVmProductsInfo(
      {required VmModel vmModel, String? location});
}
