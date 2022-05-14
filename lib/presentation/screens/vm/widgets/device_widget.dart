import 'package:flutter/material.dart';
import 'package:pay_drink/presentation/screens/vm_details/vm_products_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pay_drink/data/mqtt.dart';
import 'package:pay_drink/domain/models/vm/vm_model.dart';
import 'package:pay_drink/theme/text_styles.dart';

class DeviceWidget extends StatelessWidget {
  final String vmType;
  final String title;
  final String deviceId;
  final VmModel vmModel;
  final VoidCallback onVmTap;
  const DeviceWidget({
    Key? key,
    required this.vmType,
    required this.title,
    required this.deviceId,
    required this.vmModel,
    required this.onVmTap,
  }) : super(key: key);

  void _deviceSelected(BuildContext context) async {
    // final _mqttData = BehaviorSubject();
    // Mqtt _mqtt = Mqtt(
    //     // configirationData: this.configurationData!,
    //     uuid: 'identifier1',
    //     deviceId: deviceId);

    // await _mqtt.connect('ee' + deviceId.toString())?.pipe(_mqttData.sink);

    // _mqttData.stream.listen((d) {
    //   print('device_widget_conection');
    // });
    // _mqtt.publishMessage('message');
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onVmTap
      // _getDeviceInfo(context);
      ,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyles.cardHeadingTextStyle,
          ),
          const SizedBox(height: 10.0),
          // Text('$companyName - $vmName'),
          // SizedBox(
          // height: MediaQuery.of(context).size.height < 700 ? 20.0 : 30),
          Text(
            'Type: ' + (vmModel.type ?? ''),
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyles.cardHeadingTextStyle,
          ),

          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 4.5,
            child: Image.asset(
              _getVmImage(vmType),
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Address: ' + (vmModel.address ?? ''),
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyles.cardHeadingTextStyle,
          ),
        ],
      ),
    );
  }

  String _getVmImage(String type) {
    String vmImage = 'assets/vm_image/3.png';
    String? orderImage;
    switch (type) {
      case 'beverages':
        vmImage = 'assets/vm_image/2.png';
        orderImage = 'assets/vm_image/2_small.png';
        break;
      case 'water':
        vmImage = 'assets/vm_image/5.png';
        orderImage = 'assets/vm_image/5_small.png';
        break;
      // case 3:
      //   vmImage = 'assets/vm_image/3.png';
      //   orderImage = 'assets/vm_image/combo_small.png';
      //   break;
      // case 'coffee:
      //   vmImage = 'assets/vm_image/1.png';
      //   orderImage = 'assets/vm_image/combo_small.png';
      //   break;
      // case 5:
      //   vmImage = 'assets/vm_image/1.png';
      //   orderImage = 'assets/vm_image/1_small.png';
      //   break;
      // case 6:
      //   vmImage = 'assets/vm_image/2.png';
      //   orderImage = 'assets/vm_image/2_small.png';
      //   break;
      // case 7:
      //   vmImage = 'assets/vm_image/4.png';
      //   orderImage = 'assets/vm_image/4_small.png';
      //   break;
      // case 8:
      //   vmImage = 'assets/vm_image/6.png';
      //   orderImage = 'assets/vm_image/6_small.png';
      //   break;
      // case 9:
      //   vmImage = 'assets/vm_image/7.png';
      //   orderImage = 'assets/vm_image/7_small.png';
      // break;
      default:
        vmImage = 'assets/vm_image/3.png';
        orderImage = 'assets/vm_image/3_small.png';
        break;
    }
    return vmImage;
  }
}
