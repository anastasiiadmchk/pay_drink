import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/domain/blocs/qr/qr_state.dart';
import 'package:pay_drink/domain/repositories/vm_repo.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCubit extends Cubit<QrState> {
  QrCubit({required VmRepo vmRepo})
      : super(const QrState(isLoadingDeviceInfoString: false)) {
    _vmRepo = vmRepo;
  }

  late final VmRepo _vmRepo;

  // Future<void> getVmModel({required String deviceInfo}) async {
  //   final stableState = state;
  //   try {
  //     emit(state.copyWith(isLoadingVmModel: true));
  //     final vmModel = await _vmRepo.getVmModel(deviceId: deviceInfo);
  //     if (vmModel != null) {
  //       emit(
  //         state.copyWith(
  //           deviceExists: true,
  //           isLoadingVmModel: false,
  //           vmModel: vmModel,
  //         ),
  //       );
  //     } else {
  //       emit(state.copyWith(deviceExists: false, isLoadingVmModel: false));
  //     }
  //   } catch (e) {
  //     emit(VmModelGetFailure());
  //     emit(stableState.copyWith(isLoadingVmModel: false, deviceExists: false));
  //   }
  // }

  void readScan(Barcode readBarcode, DateTime currentScan) async {
    final stableState = state;
    try {
      // if (widget.isVmScanner) {
      emit(state.copyWith(
        lastScan: currentScan,
        canScan: false,
        isLoadingDeviceInfoString: true,
      ));
      if (readBarcode.code?.contains('qr=') ?? false) {
        final qrCodeArray = readBarcode.code!.split('qr=');
        if (qrCodeArray.isNotEmpty) {
          final qrCode = qrCodeArray.last;
          if (qrCode.isNotEmpty) {
            emit(state.copyWith(
              isLoadingDeviceInfoString: false,
              deviceInfo: qrCode,
            ));
            // emit(StartFetchingVmModel());
            return;

            // getVmModel(deviceInfo: qrCode);
            // await verifyDeviceExistance(qrCode);
          } else {
            emit(state.copyWith(
              deviceInfo: null,
              canScan: true,
              isLoadingVmModel: false,
              deviceExists: false,
            ));
            return;
          }
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            emit(state.copyWith(
              canScan: true,
              isLoadingDeviceInfoString: false,
            ));
          });
        }
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          emit(state.copyWith(
            canScan: true,
            isLoadingDeviceInfoString: false,
          ));
        });
      }
      // } else {
      //   final trimmedCode = readBarcode.code.replaceAll(new RegExp(r'\s+'), '');
      //   await verifyProductNumber(trimmedCode);
      //   Future.delayed(const Duration(seconds: 1), () {
      //     _canScan = true;
      //   });
      // }
    } catch (e) {
      emit(QrGetFailure());
      emit(stableState.copyWith(isLoadingDeviceInfoString: false));
    }
  }

  Future<void> onQRViewCreated(QRViewController controller) async {
    final stableState = state;
    try {
      final flashStatus = await controller.getFlashStatus();
      emit(state.copyWith(flashLightState: flashStatus));

      controller.scannedDataStream.listen((scanData) {
        final currentScan = DateTime.now();
        if (state.canScan &&
            (state.lastScan == null ||
                currentScan.difference(state.lastScan!) >
                    const Duration(seconds: 3))) {
          emit(state.copyWith(
            lastScan: currentScan,
            canScan: false,
            isLoadingDeviceInfoString: true,
          ));
          // readScan(scanData);
        }
      });
    } catch (e) {
      emit(VmModelGetFailure());
      emit(stableState.copyWith(isLoadingDeviceInfoString: false));
    }
  }

  void setCurrentScan(DateTime currentScan) {
    final stableState = state;
    try {
      emit(state.copyWith(
        lastScan: currentScan,
        canScan: false,
        isLoadingDeviceInfoString: true,
      ));
    } catch (e) {
      emit(QrFailure());
      emit(stableState.copyWith(isLoadingDeviceInfoString: false));
    }
  }

  void dispose() {
    final stableState = state;
    try {
      emit(state.copyWith(
        deviceInfo: null,
        canScan: true,
        isLoadingVmModel: false,
        isLoadingDeviceInfoString: false,
      ));
    } catch (e) {
      emit(QrFailure());
      emit(stableState.copyWith(isLoadingDeviceInfoString: false));
    }
  }

  Future<void> verifyDeviceExistance(String deviceInfo) async {
    final stableState = state;
    try {
      emit(state.copyWith(
        canScan: false,
        isLoadingVmModel: true,
      ));
      final vmModel = await _vmRepo.getVmModel(deviceId: deviceInfo);
      if (vmModel != null) {
        emit(
          state.copyWith(
            deviceExists: true,
            isLoadingVmModel: false,
            vmModel: vmModel,
            deviceInfo: deviceInfo,
            canScan: true,
          ),
        );
      } else {
        emit(state.copyWith(
          deviceInfo: null,
          canScan: true,
          isLoadingVmModel: false,
          deviceExists: false,
        ));
      }
    } catch (e) {
      emit(QrFailure());
      emit(stableState.copyWith(isLoadingDeviceInfoString: false));
    }
  }
}
