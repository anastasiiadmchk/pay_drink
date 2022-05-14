import 'package:firebase_database/firebase_database.dart';

// class VmStatisticRepoImpl implements VmStatisticRepo {
//   final _database = FirebaseDatabase.instance
//     ..setPersistenceCacheSizeBytes(10000000)
//     ..setPersistenceEnabled(true);
//   @override
//   Future<List<ProductHistory?>?> getProductsHistory(
//       {required VmModel vmModel, String? location}) async {
//     location = 'kyiv_city/';
//     final category = (vmModel.products?.first.category != null ? '/' : '') +
//         (vmModel.products?.first.category ?? '');
//     final beveragesList = vmModel.products?.first.categoryProducts;
//     List<ProductHistory?>? productsList = [];
//     try {
//       if (beveragesList?.isNotEmpty ?? false) {
//         for (final e in beveragesList!) {
//           if (e.id != null) {
//             print(e.id);
//             final DatabaseEvent record = await _database
//                 .ref(location + vmModel.id + category + '/' + e.id!)
//                 .once();
//             print(record.snapshot.value);
//             final List<int> numbers = record.snapshot.children
//                 .map((number) =>
//                     int.tryParse((number.value as Map?)?['number'] ?? '0') ?? 0)
//                 .toList();
//             print(numbers);

//             productsList.add(ProductHistory(e, numbers));
//           }
//         }
//         return productsList;
//       }
//     } catch (e, s) {
//       logError('VmStatisticRepoImpl::getVmModelInfo:', error: e, stackTrace: s);
//       return null;
//     }
//     return null;
//   }
// }
