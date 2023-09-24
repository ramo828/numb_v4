import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: camel_case_types
class func {
  String alpabetical_order(int counter) {
    if (counter <= 10) {
      return '_A';
    } else if (counter > 10) {
      return '_B';
    } else if (counter > 10 && counter <= 100) {
      return '_C';
    } else if (counter > 100 && counter <= 1000) {
      return '_D';
    } else {
      return "_E";
    }
  }

  List<String> dataVcard = [
    "BEGIN:VCARD\n",
    "N:",
    "FN:",
    "TEL;TYPE=WORK,MSG:",
    "EMAIL;TYPE=INTERNET:\n",
    "END:VCARD\n"
  ];

  List<String> defaultPrefix = [
    "+99450",
    "+99451",
    "+99410",
    "+99455",
    "+99499",
    "+99470",
    "+99477",
    "+99460"
  ];

  String splitNumberData(String data) {
    // ignore: unnecessary_null_comparison
    if (data.isNotEmpty || data != null) {
      String pref = data.substring(0, 2);
      String a1 = data.substring(2, 5);
      String a2 = data.substring(5, 7);
      String a3 = data.substring(7, 9);

      return "0$pref-$a1-$a2-$a3";
    } else {
      throw ("Boş və ya null data göndərilə bilməz!");
    }
  }

  String vcf(String contactName, List<String> prefix, int prefixIndex,
      String number, int counter) {
    try {
      return "${dataVcard[0]}${dataVcard[1]}$contactName${alpabetical_order(counter)}$counter\n${dataVcard[2]}$contactName${alpabetical_order(counter)}$counter\n${dataVcard[3]}${prefix[prefixIndex]}${number.substring(number.length > 10 ? 5 : 2, number.length)}\n${dataVcard[4]}${dataVcard[5]}";
    } catch (e, s) {
      print(e);
      print(s);
      // throw (e);
      return "";
    }
  }

  String vcfRaw(String contactName, String number, int counter) {
    try {
      return "${dataVcard[0]}${dataVcard[1]}$contactName$counter\n${dataVcard[2]}$contactName$counter\n${dataVcard[3]}$number\n${dataVcard[4]}${dataVcard[5]}";
    } catch (e, s) {
      print(e);
      print(s);
      return "";
    }
  }
}

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

Future<void> saveStringList(String key, List<String> valueList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(key, valueList);
}

Future<List<String>> getStringList(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(key) ?? []; // Varsayılan değer boş liste
}

void launchURLupdate(String link) async {
  Uri uri = Uri.parse(link);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $link';
  }
}

void showSnackBar(
  BuildContext context,
  String message,
  int second,
) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: second),
  );

  ScaffoldMessenger.of(context)
      .showSnackBar(snackBar); // ScaffoldMessenger ile SnackBar göster
}

Future<void> requestPermissions() async {
  var statusStorage = await Permission.storage.status;
  var statusManageExternalStorage =
      await Permission.manageExternalStorage.status;

  if (statusStorage.isGranted && statusManageExternalStorage.isGranted) {
    // İzinler verildi, istediğiniz işlemi burada gerçekleştirin.
    print("İzinler verildi. İşlem yapılabilir.");
    // Örneğin, dosya yazma işlemini burada gerçekleştirebilirsiniz.
  } else {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    // İzinler verilmedi, kullanıcıdan izin istemek yerine işlemi iptal edebilirsiniz.
    print("İzinler verilmedi. İşlem iptal edildi.");
  }
}

Future<void> zipFile(String sourceFilePath, String zipFilePath) async {
  final encoder = ZipFileEncoder();

  final sourceFile = File(sourceFilePath);

  if (!sourceFile.existsSync()) {
    print('Kaynak dosya bulunamadı: $sourceFilePath');
    return;
  }

  final sourceFileName = sourceFile.uri.pathSegments.last;

  encoder.create(zipFilePath);
  encoder.addFile(sourceFile, sourceFileName);

  encoder.close();
  print('Dosya başarıyla sıkıştırıldı: $zipFilePath');
}

// Firestore'da belirli bir koleksiyon ve belgeyi güncelleme fonksiyonu
Future<void> dataUpdate(
    String collection, String document, Map<String, dynamic> data) async {
  try {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(document)
        .update(data);
    print('Veri başarıyla güncellendi');
  } catch (e) {
    print('Veri güncellenirken bir hata oluştu: $e');
  }
}
