import 'package:device_info_plus/device_info_plus.dart';

Future<String> getDeviceID() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('Running on ${androidInfo.id}'); // e.g. "Moto G (4)"
  return androidInfo.id;
}
