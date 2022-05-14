import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:flutter/widgets.dart';
import 'package:pay_drink/core/utils/toast_notification_utils.dart';

class ToastReportHandler extends ReportHandler {
  @override
  List<PlatformType> getSupportedPlatforms() {
    return <PlatformType>[PlatformType.android, PlatformType.iOS];
  }

  @override
  Future<bool> handle(Report error, BuildContext? context) async {
    if (context != null) {
      ToastNotificationUtils.showToast(
        context,
        message:
            'Unexpected error has occurred. Please bear with us, we are working on it.',
        toastType: ToastType.error,
      );
    }
    return true;
  }
}
