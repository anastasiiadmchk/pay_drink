import 'package:pay_drink/domain/models/vm/vm_model.dart';

class VmState {
  // final bool isLoading;
  // final List<VmModel>? vms;
  final bool isLoadingVmModel;
  final VmModel? vmModel;
  final bool deviceExists;
  const VmState({
    // this.vms,
    // this.isLoading = false,
    this.deviceExists = false,
    this.vmModel,
    this.isLoadingVmModel = false,
  });

  VmState copyWith({
    // bool? isLoading,
    // List<VmModel>? vms,
    bool? isLoadingVmModel,
    bool? deviceExists,
    VmModel? vmModel,
  }) {
    return VmState(
      // isLoading: isLoading ?? this.isLoading,
      // vms: vms ?? this.vms,
      isLoadingVmModel: isLoadingVmModel ?? this.isLoadingVmModel,
      deviceExists: deviceExists ?? this.deviceExists,
      vmModel: vmModel ?? this.vmModel,
    );
  }
}

class VmModelGetFailure extends VmFailure {}

class VmGetFailure extends VmFailure {}

class VmFailure extends VmState {
  final String? error;
  VmFailure({this.error});
}
