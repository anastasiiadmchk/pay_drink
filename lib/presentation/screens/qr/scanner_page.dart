import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/domain/blocs/qr/qr_cubit.dart';
import 'package:pay_drink/domain/blocs/qr/qr_state.dart';
import 'package:pay_drink/presentation/screens/qr/widgets/drawer_widget.dart';
import 'package:pay_drink/presentation/screens/vm/vm_screen.dart';
import 'package:pay_drink/presentation/screens/vm_details/vm_products_screen.dart';
import 'package:pay_drink/theme/app_colors.dart';
import 'dart:async';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:ui';

import 'package:rxdart/subjects.dart';
import 'package:wakelock/wakelock.dart';

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class ScannerPage extends StatefulWidget {
  const ScannerPage({
    Key? key,
    this.callback,
  }) : super(key: key);
  final Function(String)? callback;
  @override
  ScannerPageState createState() => ScannerPageState();
}

class ScannerPageState extends State<ScannerPage> {
  late final QrCubit qrCubit;
  QRViewController? controller;
  String? phone;

  BehaviorSubject<bool?> _flashLightState = BehaviorSubject<bool?>();
  final TextEditingController _searchTextController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode focusNode = FocusNode();
  bool _isManualEntering = false;

  @override
  void initState() {
    Wakelock.toggle(enable: false);
    qrCubit = context.read();
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.toggle(enable: true);
    controller?.dispose();
    qrCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          // For Android.
          // Use [light] for white status bar and [dark] for black status bar.
          statusBarIconBrightness: Brightness.dark,
          // For iOS.
          // Use [dark] for white status bar and [light] for black status bar.
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
            key: _scaffoldKey,
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: _menu(),
            drawer:
                drawer(context: context, phone: phone, controller: controller),
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: BlocConsumer<QrCubit, QrState>(
                bloc: qrCubit,
                listener: (BuildContext context, QrState qrState) {
                  if (qrState.deviceInfo != null) {
                    NavigationUtil.toScreen(
                        context: context,
                        screen: VMScreen(deviceInfo: qrState.deviceInfo!));
                  }
                },
                builder: (BuildContext context, QrState qrState) {
                  return Stack(fit: StackFit.expand, children: [
                    _buildQrView(),
                    _colorFilter(),
                    /* StreamBuilder(
                    stream: BlocProvider.instance.processingBloc.isLoading,
                    builder: (c, AsyncSnapshot<bool> snapshot) {
                      return */
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: _isManualEntering
                                          ? MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom +
                                              20
                                          : 80.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(children: [
                                          AnimatedOpacity(
                                              curve: Curves.easeInOut,
                                              duration: const Duration(
                                                  milliseconds: 190),
                                              opacity:
                                                  _isManualEntering ? 1.0 : 0.0,
                                              child: AnimatedContainer(
                                                  curve: Curves.easeInOut,
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  height: 50.0,
                                                  width: _isManualEntering
                                                      ? MediaQuery.of(context)
                                                                  .size
                                                                  .width <
                                                              400
                                                          ? 200
                                                          : 250.0
                                                      : 180.0,
                                                  child: TextField(
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    keyboardType:
                                                        /* ? TextInputType.number
                                                        : */
                                                        const TextInputType
                                                                .numberWithOptions(
                                                            decimal: true),
                                                    focusNode: focusNode,
                                                    onChanged: (string) {},
                                                    onEditingComplete: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.black87),
                                                    decoration: const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        1.0,
                                                                    horizontal:
                                                                        12.0),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        25.0)))),
                                                    controller:
                                                        _searchTextController,
                                                  ))),
                                          AnimatedOpacity(
                                              curve: Curves.easeInOut,
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              opacity:
                                                  _isManualEntering ? 0.0 : 1.0,
                                              child: AnimatedContainer(
                                                  curve: Curves.easeInOut,
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  height: 50.0,
                                                  width: _isManualEntering
                                                      ? MediaQuery.of(context)
                                                                  .size
                                                                  .width <
                                                              400
                                                          ? 200
                                                          : 250.0
                                                      : 180.0,
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        try {
                                                          controller!
                                                              .getFlashStatus()
                                                              .then((value) {
                                                            if (value!) {
                                                              controller!
                                                                  .toggleFlash();

                                                              controller!
                                                                  .getFlashStatus()
                                                                  .then((value) =>
                                                                      _flashLightState
                                                                          .add(
                                                                              value));
                                                            }
                                                          });
                                                        } catch (e) {
                                                          print(e.toString());
                                                        }
                                                        if (!_isManualEntering) {
                                                          _isManualEntering =
                                                              !_isManualEntering;
                                                          focusNode
                                                              .requestFocus();
                                                        }
                                                      },
                                                      child: StreamBuilder(
                                                          stream:
                                                              _flashLightState
                                                                  .stream,
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot<
                                                                      bool?>
                                                                  snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              return GestureDetector(
                                                                  onTap: () {
                                                                    if (!_isManualEntering) {
                                                                      try {
                                                                        controller!
                                                                            .toggleFlash();
                                                                        controller!
                                                                            .getFlashStatus()
                                                                            .then((value) =>
                                                                                _flashLightState.add(value));
                                                                      } catch (e) {
                                                                        print(e
                                                                            .toString());
                                                                      }
                                                                    } else {
                                                                      if (_isManualEntering) {
                                                                        _isManualEntering =
                                                                            !_isManualEntering;
                                                                        FocusScope.of(context)
                                                                            .requestFocus(FocusNode());
                                                                      }
                                                                      final trimmedString =
                                                                          _searchTextController
                                                                              .text;

                                                                      NavigationUtil.toScreen(
                                                                          context:
                                                                              context,
                                                                          screen:
                                                                              VMScreen(deviceInfo: trimmedString));
                                                                      // if (widget
                                                                      //     .isVmScanner) {
                                                                      // qrCubit. verifyVmNumber(
                                                                      //     trimmedString);
                                                                      // }
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    child: Center(
                                                                        child: Icon(
                                                                      _isManualEntering
                                                                          ? Icons
                                                                              .done
                                                                          : Icons
                                                                              .highlight,
                                                                      color: _isManualEntering
                                                                          ? Colors
                                                                              .white
                                                                          : (snapshot.data != null && snapshot.data!
                                                                              ? AppColors.facebookColor
                                                                              : Colors.white),
                                                                      size: _isManualEntering
                                                                          ? 30.0
                                                                          : 25.0,
                                                                    )),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius: const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              30.0)),
                                                                      color: _isManualEntering
                                                                          ? AppColors
                                                                              .facebookColor
                                                                          : (snapshot.data != null && snapshot.data!
                                                                              ? Colors.white
                                                                              : AppColors.facebookColor),
                                                                    ),
                                                                    height: _isManualEntering
                                                                        ? 60.0
                                                                        : 50.0,
                                                                    width: _isManualEntering
                                                                        ? 60.0
                                                                        : 50.0,
                                                                  ));
                                                            } else {
                                                              return GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    if (!_isManualEntering) {
                                                                      if (controller !=
                                                                          null) {
                                                                        try {
                                                                          controller!
                                                                              .toggleFlash();
                                                                          controller!
                                                                              .getFlashStatus()
                                                                              .then((value) => _flashLightState.add(value));
                                                                        } catch (e) {
                                                                          print(
                                                                              e.toString());
                                                                        }
                                                                      }
                                                                    } else {
                                                                      if (_isManualEntering) {
                                                                        _isManualEntering =
                                                                            !_isManualEntering;
                                                                        FocusScope.of(context)
                                                                            .requestFocus(FocusNode());
                                                                      }
                                                                      final trimmedString =
                                                                          _searchTextController
                                                                              .text;

                                                                      NavigationUtil.toScreen(
                                                                          context:
                                                                              context,
                                                                          screen:
                                                                              VMScreen(deviceInfo: trimmedString));

                                                                      // await qrCubit
                                                                      //     .verifyDeviceExistance(
                                                                      //         trimmedString);
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    child: Center(
                                                                        child: Icon(
                                                                      _isManualEntering
                                                                          ? Icons
                                                                              .done
                                                                          : Icons
                                                                              .highlight,
                                                                      color: Colors
                                                                          .white,
                                                                      size: _isManualEntering
                                                                          ? 30.0
                                                                          : 25.0,
                                                                    )),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.all(Radius.circular(_isManualEntering
                                                                            ? 30.0
                                                                            : 25.0)),
                                                                        color: AppColors
                                                                            .facebookColor),
                                                                    height: _isManualEntering
                                                                        ? 60.0
                                                                        : 50.0,
                                                                    width: _isManualEntering
                                                                        ? 60.0
                                                                        : 50.0,
                                                                  ));
                                                            }
                                                          }))))
                                        ])
                                      ])),
                              // }),
                              AnimatedPositioned(
                                  curve: Curves.easeInOut,
                                  left: (MediaQuery.of(context).size.width /
                                          2.0) -
                                      100.0,
                                  duration: const Duration(milliseconds: 250),
                                  top: _isManualEntering
                                      ? (MediaQuery.of(context).size.height /
                                              2.0 -
                                          200.0)
                                      : -100.0,
                                  child: AnimatedOpacity(
                                      opacity: _isManualEntering ? 1.0 : 0.0,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_isManualEntering) {
                                            _isManualEntering =
                                                !_isManualEntering;
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          }
                                        },
                                        child: Stack(children: [
                                          Container(
                                              width: 200.0,
                                              height: 200.0,
                                              decoration: const ShapeDecoration(
                                                shape: OverlayShape(
                                                    borderColor: Colors.white,
                                                    borderRadius: 14.0,
                                                    borderLength: 20.0,
                                                    borderWidth: 5.0,
                                                    cutOutSize: 80.0),
                                              )),
                                          Positioned(
                                              top: 90.0,
                                              left: intl.Intl
                                                          .getCurrentLocale() ==
                                                      'ua'
                                                  ? 34.0
                                                  : 46,
                                              child: Text(
                                                  'scannerPageContinueScanningMessage'
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.white
                                                          .withOpacity(0.6),
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ]),
                                      ))),
                            ])),
                  ]);
                })));
  }

  Widget _buildQrView() {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? MediaQuery.of(context).size.width - 50
        : MediaQuery.of(context).size.width - 50;

    return QRView(
      key: qrKey,
      onQRViewCreated: (qrController) {
        controller = qrController;
        qrCubit.onQRViewCreated(qrController);
      },
      overlay: QrScannerOverlayShape(
          overlayColor: Colors.black.withOpacity(_isManualEntering ? 0 : 0.8),
          borderColor: Colors.white,
          borderRadius: 14.0,
          borderLength: 38.0,
          borderWidth: 5.0,
          cutOutSize: scanArea),
    );
  }

  Widget _menu() {
    return FloatingActionButton(
      backgroundColor: AppColors.milkWhite,
      child: Icon(ModalRoute.of(context)!.isFirst ? Icons.menu : Icons.close),
      elevation: 8,
      onPressed: () {
        _isManualEntering = false;
        _searchTextController.text = '';

        FocusScope.of(context).requestFocus(FocusNode());
        ModalRoute.of(context)!.isFirst
            ? _scaffoldKey.currentState!.openDrawer()
            : Navigator.of(context, rootNavigator: true).pop();
      },
    );
  }

  void showDemoDialog<T>({required BuildContext context, Widget? child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child!,
    );
  }

  ColorFiltered _colorFilter() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(_isManualEntering ? 0.8 : 0),
        BlendMode.srcOut,
      ), // This one will create the magic
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              if (_isManualEntering) {
                _isManualEntering = !_isManualEntering;
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                backgroundBlendMode: BlendMode.dstOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OverlayShape extends ShapeBorder {
  const OverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 60),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
    this.cutOutBottomOffset = 0,
  }) : assert(borderLength <= cutOutSize / 2 + borderWidth * 2,
            "Border can't be larger than ${cutOutSize / 2 + borderWidth * 2}");

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;
  final double cutOutBottomOffset;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final _borderLength = borderLength > cutOutSize / 2 + borderWidth * 2
        ? borderWidthSize / 2
        : borderLength;
    final _cutOutSize = cutOutSize < width ? cutOutSize : width - borderOffset;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - _cutOutSize / 2 + borderOffset,
      -cutOutBottomOffset +
          rect.top +
          height / 2 -
          _cutOutSize / 2 +
          borderOffset,
      _cutOutSize - borderOffset * 2,
      _cutOutSize - borderOffset * 2,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      // ..drawRect(
      //   rect,
      //   backgroundPaint,
      // )
      // Draw top right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - _borderLength,
          cutOutRect.top,
          cutOutRect.right,
          cutOutRect.top + _borderLength,
          topRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw top left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.top,
          cutOutRect.left + _borderLength,
          cutOutRect.top + _borderLength,
          topLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - _borderLength,
          cutOutRect.bottom - _borderLength,
          cutOutRect.right,
          cutOutRect.bottom,
          bottomRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.bottom - _borderLength,
          cutOutRect.left + _borderLength,
          cutOutRect.bottom,
          bottomLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
