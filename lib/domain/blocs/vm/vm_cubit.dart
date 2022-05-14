import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/domain/blocs/vm/vm_state.dart';
import 'package:pay_drink/domain/repositories/vm_repo.dart';

class VmCubit extends Cubit<VmState> {
  VmCubit({required VmRepo vmRepo})
      : super(const VmState(isLoadingVmModel: false)) {
    _vmRepo = vmRepo;
  }

  late final VmRepo _vmRepo;

  // Future<void> getAllVms() async {
  //   final stableState = state;
  //   try {
  //     emit(state.copyWith(isLoading: true));
  //     final list = await _vmRepo.getVmModelsList();
  //     emit(state.copyWith(vms: list, isLoading: false));
  //   } catch (e) {
  //     emit(AllVmGetFailure());
  //     emit(stableState.copyWith(isLoading: false));
  //   }
  // }

  Future<void> getVmModel({required String deviceInfo}) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoadingVmModel: true));
      final vmModel = await _vmRepo.getVmModel(deviceId: deviceInfo);
      if (vmModel != null) {
        emit(
          state.copyWith(
            deviceExists: true,
            isLoadingVmModel: false,
            vmModel: vmModel,
          ),
        );
      } else {
        emit(state.copyWith(deviceExists: false, isLoadingVmModel: false));
      }
    } catch (e) {
      emit(VmModelGetFailure());
      emit(stableState.copyWith(isLoadingVmModel: false, deviceExists: false));
    }
  }
}
