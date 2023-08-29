import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

Future<String> getDeviceID() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('Running on ${androidInfo.id}'); // e.g. "Moto G (4)"
  return androidInfo.id;
}

Future<bool> equalDeviceID(String id1) async {
  String id2 = await getDeviceID();
  if (id2.contains(id1)) {
    print("ID1:$id1");
    return true;
  } else {
    print("ID2:$id2");

    return false;
  }
}
