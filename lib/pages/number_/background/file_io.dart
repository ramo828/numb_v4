import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<void> writeData(String data) async {
  // final directory =
  //     await getExternalStorageDirectory(); // Cihazın dış hafızasına erişim sağlar
  final directory = "/sdcard/work/";
  final file = File('${directory}test.txt');
  await file.writeAsString(data);
}

Future<String> readData() async {
  final directory = "/sdcard/work/";
  // final directory = await getExternalStorageDirectory();
  final file = File('${directory}test.txt');
  String data = await file.readAsString();
  return data;
}
