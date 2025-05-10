import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodbridge_volunteers_flutter/core/utils/device_helper.dart';

class AppUrl {
  static Future<String> getBaseUrl() async {
    final isPhysical = await DeviceHelper.isPhysicalDevice();
    final isRelease = const bool.fromEnvironment("dart.vm.product");

    if (isRelease) {
      return dotenv.env['BASE_URL_PROD']!;
    } else {
      return isPhysical
          ? dotenv.env['BASE_URL_DEVICE']!
          : dotenv.env['BASE_URL_LOCAL']!;
    }
  }
}
