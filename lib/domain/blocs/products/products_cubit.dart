import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/domain/blocs/products/products_state.dart';
import 'package:pay_drink/domain/models/vm/vm_model.dart';
import 'package:pay_drink/domain/repositories/real_db_repo.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({required RealDbRepo realDbRepo})
      : super(const ProductsState(isLoading: false)) {
    _realDbRepo = realDbRepo;
  }

  late final RealDbRepo _realDbRepo;

  Future<void> getAllProductsNumber({required VmModel vmModel}) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      final list = await _realDbRepo.getVmProductsInfo(vmModel: vmModel);
      emit(state.copyWith(productsNumber: list, isLoading: false));
    } catch (e) {
      emit(VmProductsGetFailure());
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
