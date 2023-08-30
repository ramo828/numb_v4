import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Future<String> getDeviceID() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('Running on ${androidInfo.fingerprint}'); // e.g. "Moto G (4)"
  return androidInfo.fingerprint;
}

String calculateMD5(String input) {
  print(input);
  var bytes = utf8.encode(input); // Metni UTF-8 formatına dönüştür
  var md54 = md5.convert(bytes); // MD5 şifrelemesi
  return md54.toString(); // Şifrelenmiş değeri geri döndür
}

Future<bool> equalDeviceID(String id1) async {
  String id2 = await getDeviceID();
  id2 = calculateMD5(id2);
  print("Gelen: $id1");
  print("cixan: $id2");
  if (id2.contains(id1)) {
    print("ID1:$id1");
    return true;
  } else {
    print("ID2:$id2");

    return false;
  }
}

Future<void> saveBoolValue(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

Future<bool> getBoolValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key) ?? false; // Varsayılan değer false
}

void launchURLupdate(String link) async {
  Uri uri = Uri.parse(link);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $link';
  }
}
