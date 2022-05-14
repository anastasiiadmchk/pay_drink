import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/domain/blocs/products/products_cubit.dart';
import 'package:pay_drink/domain/blocs/products/products_state.dart';
import 'package:pay_drink/domain/models/vm/vm_model.dart';
import 'package:pay_drink/presentation/components/widgets/card_widget.dart';
import 'package:pay_drink/presentation/components/widgets/loading_indicator.dart';
import 'package:pay_drink/presentation/screens/payment/payment_screen.dart';

import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class VmDetailsScreen extends StatefulWidget {
  final VmModel vmModel;
  const VmDetailsScreen({Key? key, required this.vmModel}) : super(key: key);

  @override
  State<VmDetailsScreen> createState() => _VmDetailsScreenState();
}

class _VmDetailsScreenState extends State<VmDetailsScreen> {
  late ProductsCubit bloc;
  @override
  void initState() {
    bloc = BlocProvider.of<ProductsCubit>(context);
    bloc.getAllProductsNumber(vmModel: widget.vmModel);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom -
        20;

    return SizedBox(
      height: height,
      child: Column(children: [
        _closeBtn(context),
        Expanded(
            child: BlocBuilder<ProductsCubit, ProductsState>(
                bloc: bloc,
                builder: (BuildContext context, ProductsState state) {
                  final products = state.productsNumber ?? [];
                  return state.isLoading
                      ? const CustomLoadingIndicator()
                      : products.isEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 16),
                              child: Text(
                                'Products are not available in the machine',
                                style: TextStyles.headingPrimaryTextStyle,
                              ),
                            )
                          : _productsList(state);
                })),
      ]),
    );
  }

  Widget _productsList(ProductsState state) {
    final products = state.productsNumber ?? [];
    return ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16),
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (BuildContext ctx, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              NavigationUtil.toScreen(
                  context: context,
                  screen: PaymentScreen(
                      product: product!, deviceId: widget.vmModel.id));
            },
            child: CardWidget(
              isLoading: state.isLoading,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 6,
                    child: Image.asset(
                      _getVmImage(product?.product?.code ?? ''),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product?.product?.name ??
                            '' + (product?.number ?? 0).toString(),
                        style: TextStyles.cardHeadingTextStyle,
                      ),
                      Text(
                        'Quantity: ' + (product?.number ?? 0).toString(),
                        style: TextStyles.cardBodyTextStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Code: ' + (product?.product?.code ?? ''),
                        style: TextStyles.bnbTextStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Provider: \n' +
                            (product?.product?.provider ?? 'Drinkee'),
                        style: TextStyles.bnbTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _closeBtn(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20.15,
          top: 24.15,
          bottom: 24.15,
        ),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.close_rounded,
            color: AppColors.uiDarkGrey,
          ),
        ),
      ),
    );
  }

  String _getVmImage(String type) {
    String vmImage = 'assets/vm_image/3.png';
    String? orderImage;
    if (type.contains('water')) {
      vmImage = 'assets/vm_image/5.png';
      orderImage = 'assets/vm_image/5_small.png';
    } else if (type.contains('juice')) {
      vmImage = 'assets/vm_image/2.png';
      orderImage = 'assets/vm_image/2_small.png';
    } else {
      vmImage = 'assets/vm_image/3.png';
      orderImage = 'assets/vm_image/combo_small.png';
    }

    return orderImage;
  }
}
