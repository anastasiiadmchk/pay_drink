import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pay_drink/core/utils/log.dart';
import 'package:pay_drink/domain/models/product/product_model.dart';
import 'package:pay_drink/domain/models/vm/vm_model.dart';
import 'package:pay_drink/domain/repositories/vm_repo.dart';

class VmRepoImpl implements VmRepo {
  final CollectionReference _vmsCollection =
      FirebaseFirestore.instance.collection('vending_machines');
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  @override
  Future<List<VmModel>?> getVmModelsList({String? location}) async {
    location = 'kyiv_city';

    try {
      List<VmModel>? devicesList = [];

      final vmsDocs =
          await _vmsCollection.doc(location).collection('machines_list').get();
      for (final vmModel in vmsDocs.docs) {
        devicesList.add(VmModel.fromJson(vmModel.data()));
      }
      final productsDocs =
          _productsCollection.doc('beverages').collection('category_products');
      List<VmModel>? newDevicesList = [];
      for (var e in devicesList) {
        final ids = e.products?.first.categoryProductsIds ?? [];

        List<Product>? products = [];

        for (final id in ids) {
          final productDoc = await productsDocs.doc(id).get();
          products.add(Product.fromJson(productDoc.data() ?? {}));
        }
        newDevicesList.add(e.copyWith(products: [
          e.products!.first.copyWith(categoryProducts: products)
        ]));
      }
      return newDevicesList;
    } catch (e, s) {
      logError('URealDbRepoImpl::getVmModelInfo:', error: e, stackTrace: s);
      return null;
    }
  }

  // @override
  // Future<VmModel?> checkDevice({required String deviceInfo}) async {
  //   // kyiv_city/device-01/beverages/
  //   String location = deviceInfo.split('/')[0];
  //   String deviceId = deviceInfo.split('/')[1];
  //   String deviceCategory = deviceInfo.split('/')[2];

  //   try {
  //     // List<VmModel>? devicesList = [];

  //     final vmDoc = await _vmsCollection
  //         .doc(location)
  //         .collection('machines_list')
  //         .doc(deviceId)
  //         .get();
  //     if (vmDoc.data() != null) {

  //       return VmModel.fromJson(vmDoc.data()!);
  //     } else {
  //       return null;
  //     }
  //     final productsDocs =
  //         _productsCollection.doc('beverages').collection('category_products');
  //     List<VmModel>? newDevicesList = [];
  //     for (var e in devicesList) {
  //       final ids = e.products?.first.categoryProductsIds ?? [];

  //       List<Product>? products = [];

  //       for (final id in ids) {
  //         final productDoc = await productsDocs.doc(id).get();
  //         products.add(Product.fromJson(productDoc.data() ?? {}));
  //       }
  //       newDevicesList.add(e.copyWith(products: [
  //         e.products!.first.copyWith(categoryProducts: products)
  //       ]));
  //     }
  //     return newDevicesList;
  //   } catch (e, s) {
  //     logError('URealDbRepoImpl::getVmModelInfo:', error: e, stackTrace: s);
  //     return null;
  //   }
  // }

  @override
  Future<VmModel?> getVmModel({required String deviceId}) async {
    // kyiv_city/device-01/beverages/

    String location = deviceId.split('/')[0];
    String id = deviceId.split('/')[1];
    String deviceCategory = deviceId.split('/')[2];

    try {
      final vmDoc = await _vmsCollection
          .doc(location)
          .collection('machines_list')
          .doc(id)
          .get();
      if (vmDoc.exists && vmDoc.data() != null) {
        VmModel? vmModel = VmModel.fromJson(vmDoc.data()!);

        final productsDocs = _productsCollection
            .doc('beverages')
            .collection('category_products');

        final ids = vmModel.products?.first.categoryProductsIds ?? [];

        List<Product>? products = [];

        for (final id in ids) {
          final productDoc = await productsDocs.doc(id).get();
          products.add(Product.fromJson(productDoc.data() ?? {}));
        }
        vmModel.copyWith(products: [
          vmModel.products!.first.copyWith(categoryProducts: products)
        ]);

        return vmModel;
      } else {
        return null;
      }
    } catch (e, s) {
      logError('URealDbRepoImpl::getVmModelInfo:', error: e, stackTrace: s);
    }
    return null;
  }
}
