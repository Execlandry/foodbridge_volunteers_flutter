import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceHelper {
  static Future<bool> isPhysicalDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.isPhysicalDevice ?? true;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.isPhysicalDevice ?? true;
      } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
        // Desktop is considered a physical device
        return true;
      }
    } catch (e) {
      print('Error checking device type: $e');
    }
    
    // Default to true if we can't determine
    return true;
  }
}
