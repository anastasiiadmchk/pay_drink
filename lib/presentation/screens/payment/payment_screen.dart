import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/domain/blocs/product/product_cubit.dart';
import 'package:pay_drink/domain/blocs/product/product_state.dart';
import 'package:pay_drink/domain/models/product_number/product_number_model.dart';
import 'package:pay_drink/presentation/components/widgets/card_widget.dart';
import 'package:pay_drink/presentation/components/widgets/custom_text_field.dart';
import 'package:pay_drink/presentation/components/widgets/loading_indicator.dart';
import 'package:pay_drink/presentation/components/widgets/question_sheet.dart';
import 'package:pay_drink/presentation/thank_you/thank_you_screen.dart';
import 'package:pay_drink/theme/text_styles.dart';

class PaymentScreen extends StatefulWidget {
  final ProductNumber product;
  final String deviceId;
  const PaymentScreen({Key? key, required this.product, required this.deviceId})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final ProductCubit _productCubit;
  final TextEditingController _productNumberController =
      TextEditingController();

  late final ValueNotifier<bool> _productNumberNotifier;
  @override
  void initState() {
    super.initState();
    _productCubit = context.read();
    _productNumberNotifier = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _productNumberController.dispose();
    _productNumberNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<ProductCubit, ProductState>(
            bloc: _productCubit,
            listener: _listener,
            builder: (BuildContext context, ProductState state) {
              return state.isLoadingPayment
                  ? const CustomLoadingIndicator()
                  : _buildBody(state);
            }));
  }

  void _onPayTap(ProductState state) {
    if (!state.isLoadingPayment) {
      _productCubit.makePayment(
          deviceId: widget.deviceId,
          productInfo: widget.product.product?.id ?? 'QpgLEYEbHdcGfAgcLTni',
          productsNumber: _productNumberController.text);
    }
  }

  void _listener(BuildContext context, ProductState state) {
    if (state is PaymentSuccess) {
      NavigationUtil.toScreenReplacement(
          context: context, screen: const ThankYouScreen());
    }
  }

  Widget _buildBody(ProductState state) {
    return Column(children: [
      QuestionSheet(
        key: const ValueKey('name'),
        onNextTap: () => _onPayTap(state),
        nextBtnTitle: 'Pay',
        onBack: () {
          NavigationUtil.popScreen(context: context);
        },
        sheetHeaderText: 'Pay & Drink',
        questions: [
          CardWidget(
            isLoading: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width / 6,
                  child: Image.asset(
                    _getVmImage(widget.product.product?.code ?? ''),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.product?.name ??
                          '' + (widget.product.number ?? 0).toString(),
                      style: TextStyles.cardHeadingTextStyle,
                    ),
                    Text(
                      'Quantity: ' + (widget.product.number ?? 0).toString(),
                      style: TextStyles.cardBodyTextStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Price: ' +
                          (widget.product.product?.price ?? 0).toString(),
                      style: TextStyles.bnbTextStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Provider: \n' +
                          (widget.product.product?.provider ?? 'Drinkee'),
                      style: TextStyles.bnbTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomTextField(
              title: 'Number of products you want to purchase',
              controller: _productNumberController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              isInputValid: _productNumberNotifier,
              textInputAction: TextInputAction.done,
              onValidate: _onValidateInput),
        ],
        isNextButtonEnabled: _productNumberNotifier,
      ),
    ]);
  }

  bool _onValidateInput(String input) {
    return (int.tryParse(input) ?? 0).toInt() <= (widget.product.number ?? 0) &&
        (int.tryParse(input) ?? 0).toInt() > 0;
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
