import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class AppUrl {
  static Future<String> getBaseUrl() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      final isEmulator = !androidInfo.isPhysicalDevice;

      return isEmulator
          ? dotenv.env['BASE_URL_LOCAL']!
          : dotenv.env['BASE_URL_DEVICE']!;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      final isEmulator = !iosInfo.isPhysicalDevice;

      return isEmulator
          ? dotenv.env['BASE_URL_LOCAL']!
          : dotenv.env['BASE_URL_DEVICE']!;
    }

    // For web/desktop fallback (if any)
    return dotenv.env['BASE_URL_LOCAL']!;
  }
}
