import 'package:flutter/material.dart';
import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/presentation/screens/profile/profile_screen.dart';
import 'package:pay_drink/theme/app_colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

Widget drawer(
    {required BuildContext context,
    Function? callback,
    String? phone,
    QRViewController? controller}) {
  // phone = '123123123123';
  return Container(
    width: 260.0,
    child: Drawer(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        color: AppColors.milkWhite,
                        padding: EdgeInsets.only(
                            left: 16.0,
                            top: MediaQuery.of(context).padding.top + 28.0,
                            bottom: 28.0,
                            right: 16),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 16.0, bottom: 16.0, right: 16.0),
                              child: Image.asset(
                                'assets/prosto_pay_logo.png',
                                height: 50.0,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            // if (phone != null && phone.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  phone != null && phone.isNotEmpty
                                      ? '+$phone'
                                      : '',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                                if (phone != null && phone.isNotEmpty)
                                  GestureDetector(
                                      onTap: () {
                                        controller?.pauseCamera();
                                        Navigator.of(context).pop();
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (
                                            BuildContext context,
                                          ) {
                                            return ProfileScreen();
                                          },
                                        )).then((value) {
                                          controller?.resumeCamera();
                                          Wakelock.toggle(enable: false);
                                        });
                                      },
                                      child: Text(
                                        'ChangePhoneButton',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      )),
                              ],
                            )
                          ],
                        )),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  controller?.pauseCamera();
                  Navigator.of(context).pop();
                  // NavigationUtil.toScreen(
                  //   context: context,
                  //   screen: WalletPage(),
                  // );
                  controller?.resumeCamera();
                  Wakelock.toggle(enable: false);
                },
                child: ListTile(
                  horizontalTitleGap: 5,
                  leading: Icon(Icons.payment_rounded),
                  title: Text(
                    'drawerWidgetWalletScreenTitle',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     controller?.pauseCamera();
              //     Navigator.of(context).pop();
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => OrderHistoryPage(),
              //         )).then((value) {
              //       controller?.resumeCamera();
              //       Network.sharedInstance.preventScreenFromLock(false);
              //     });
              //   },
              //   child: ListTile(
              //     horizontalTitleGap: 5,
              //     leading: Icon(Icons.access_time),
              //     title: Text(
              //       S.of(context).drawerWidgetOrderHistoryScreenTitle,
              //       style: TextStyle(color: Colors.black87),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 1,
                ),
              ),
              // InkWell(
              //   onTap: () async {
              //     await canLaunch('https://prostopay.net/docs/privacy.html')
              //         // ignore: unnecessary_statements
              //         ? {
              //             await launch(
              //                 'https://prostopay.net/docs/privacy.html',
              //                 enableJavaScript: true,
              //                 forceWebView: false,
              //                 forceSafariVC: false),
              //             Navigator.of(context).pop()
              //           }
              //         : print(
              //             'Could not launch https://prostopay.net/docs/privacy.html');
              //     // https://prostopay.net/docs/privacy.html
              //   },
              //   child: ListTile(
              //     horizontalTitleGap: 5,
              //     leading: Icon(Icons.info_outline_rounded),
              //     title: Text(
              //       S.of(context).drawerWidgetUsageAgreementScreenTitle,
              //       style: TextStyle(color: Colors.black87),
              //     ),
              //   ),
              // ),
              // InkWell(
              //   onTap: () async {
              //     // Clipboard.setData(new ClipboardData(
              //     //         text: BlocProvider.instance.processingBloc.tttt))
              //     //     .then((_) {});
              //     try {
              //       await launch(Uri(
              //         scheme: 'tel',
              //         path: '+38 (067) 445 96 79',
              //       ).toString());
              //     } catch (e) {
              //       print('Could not tel');
              //     }
              //   },
              //   child: ListTile(
              //     horizontalTitleGap: 5,
              //     leading: Icon(Icons.phone),
              //     title: Text(
              //       S.of(context).drawerWidgetCallUsButton,
              //       style: TextStyle(color: Colors.black87),
              //     ),
              //   ),
              // ),
              Spacer(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Expanded(
              //       child: Container(
              //           alignment: Alignment.center,
              //           child: Image.asset(
              //             'assets/menu_logo.png',
              //             height: 40.0,
              //             fit: BoxFit.fitHeight,
              //           )),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    ),
  );
}
