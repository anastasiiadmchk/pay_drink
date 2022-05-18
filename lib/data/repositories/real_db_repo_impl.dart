import 'package:firebase_database/firebase_database.dart';
import 'package:pay_drink/core/utils/log.dart';
import 'package:pay_drink/domain/models/product_number/product_number_model.dart';
import 'package:pay_drink/domain/models/vm/vm_model.dart';
import 'package:pay_drink/domain/repositories/real_db_repo.dart';

class RealDbRepoImpl implements RealDbRepo {
  final _database = FirebaseDatabase.instance
    ..setPersistenceCacheSizeBytes(10000000)
    ..setPersistenceEnabled(true);

  @override
  Future<List<ProductNumber?>?> getVmProductsInfo(
      {required VmModel vmModel, String? location}) async {
    location = 'kyiv_city/';
    final category = (vmModel.products?.first.category != null ? '/' : '') +
        (vmModel.products?.first.category ?? '');
    final beveragesList = vmModel.products?.first.categoryProducts;
    List<ProductNumber?> productsList = [];
    try {
      if (beveragesList?.isNotEmpty ?? false) {
        for (final e in beveragesList!) {
          if (e.id != null) {
            print(e.id);

            ///TO DO: change to sort on dateTime
            // final DatabaseEvent record =
            await _database
                .ref(location + vmModel.id + category + '/' + e.id!)
                .get()
                .then((record) {
              // .once();
              print(record.value);
              if (record.value != null) {
                final List<int> numbers = record.children
                    .map((number) =>
                        int.tryParse(
                            (number.value as Map?)?['number'] ?? '0') ??
                        0)
                    .toList();
                print(numbers);

                ///TO DO: change to sort on dateTime
                productsList.add(ProductNumber(e, numbers.last));
              }
            });
          }
        }
        return productsList;
      }
    } catch (e, s) {
      logError('URealDbRepoImpl::getVmModelInfo:', error: e, stackTrace: s);
      return null;
    }
    return null;
  }
}
