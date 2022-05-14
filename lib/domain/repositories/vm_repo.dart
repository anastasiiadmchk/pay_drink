import 'package:pay_drink/domain/models/vm/vm_model.dart';

abstract class VmRepo {
  Future<List<VmModel>?> getVmModelsList({String? location});
  Future<VmModel?> getVmModel({required String deviceId});
}
