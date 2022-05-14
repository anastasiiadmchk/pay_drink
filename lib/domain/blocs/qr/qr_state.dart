import 'package:pay_drink/domain/models/vm/vm_model.dart';

class QrState {
  final bool isLoadingVmModel;
  final bool isLoadingDeviceInfoString;
  final String? deviceInfo;
  final VmModel? vmModel;
  final bool deviceExists;
  final bool canScan;
  final bool flashLightState;
  final DateTime? lastScan;
  // final bool isManualEntering;
  const QrState({
    this.deviceExists = false,
    this.deviceInfo,
    this.isLoadingDeviceInfoString = false,
    this.vmModel,
    this.canScan = true,
    this.flashLightState = false,
    this.isLoadingVmModel = false,
    this.lastScan,
    // this.isManualEntering = false,
  });

  QrState copyWith({
    bool? isLoadingVmModel,
    String? deviceInfo,
    bool? deviceExists,
    bool? isLoadingDeviceInfoString,
    VmModel? vmModel,
    bool? canScan,
    DateTime? lastScan,
    bool? flashLightState,
    // bool? isManualEntering,
  }) {
    return QrState(
      isLoadingVmModel: isLoadingVmModel ?? this.isLoadingVmModel,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      deviceExists: deviceExists ?? this.deviceExists,
      vmModel: vmModel ?? this.vmModel,
      isLoadingDeviceInfoString:
          isLoadingDeviceInfoString ?? this.isLoadingDeviceInfoString,
      canScan: canScan ?? this.canScan,
      flashLightState: flashLightState ?? this.flashLightState,
      lastScan: lastScan ?? this.lastScan,
      // isManualEntering: isManualEntering ?? this.isManualEntering,
    );
  }
}

class StartFetchingVmModel extends QrState {}

class VmModelGetFailure extends QrFailure {}

class QrGetFailure extends QrFailure {}

class QrFailure extends QrState {
  final String? error;
  QrFailure({this.error});
}
