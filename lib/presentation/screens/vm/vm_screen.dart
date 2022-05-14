import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/domain/blocs/vm/vm_cubit.dart';
import 'package:pay_drink/domain/blocs/vm/vm_state.dart';
import 'package:pay_drink/domain/models/vm/vm_model.dart';

import 'package:pay_drink/presentation/components/widgets/card_widget.dart';
import 'package:pay_drink/presentation/components/widgets/loading_indicator.dart';
import 'package:pay_drink/presentation/screens/vm/widgets/device_widget.dart';
import 'package:pay_drink/presentation/screens/vm_details/vm_products_screen.dart';

class VMScreen extends StatefulWidget {
  final String deviceInfo;
  const VMScreen({Key? key, required this.deviceInfo}) : super(key: key);

  @override
  State<VMScreen> createState() => _VMScreenState();
}

class _VMScreenState extends State<VMScreen> {
  late VmCubit bloc;
  @override
  void initState() {
    bloc = BlocProvider.of<VmCubit>(context);
    bloc.getVmModel(deviceInfo: widget.deviceInfo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VmCubit, VmState>(
          bloc: bloc,
          builder: (BuildContext context, VmState state) {
            final device = state.vmModel;
            if (state.isLoadingVmModel) {
              return const CustomLoadingIndicator();
            } else if (!state.deviceExists) {
              return Text('Fetching device error');
            } else {
              return CardWidget(
                isLoading: state.isLoadingVmModel,
                child: DeviceWidget(
                  // title: myProducts[index]["name"],
                  // vmType: myProducts[index]["type"],
                  // deviceId: myProducts[index]["id"],
                  title: 'Device ' + (device?.id ?? ''),
                  onVmTap: () => _getDeviceInfo(context, device!),
                  vmType: device?.type ?? '',
                  deviceId: device?.id ?? '',
                  vmModel: device!,
                ),
              );
            }
          }),
    );
  }

  void _getDeviceInfo(BuildContext context, VmModel vmModel) {
    showModalBottomSheet(
        barrierColor: Colors.black38,
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Material(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: Colors.white,
              child: VmDetailsScreen(
                vmModel: vmModel,
              ),
            ),
          );
        });
  }
}
