import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<void> writeData(String data, String filename) async {
  // final directory =
  //     await getExternalStorageDirectory(); // Cihazın dış hafızasına erişim sağlar
  _createFolder();
  final directory = "/sdcard/work/";
  final file = File('${directory}${filename}');
  await file.writeAsString(data);
}

Future<String> readData() async {
  final directory = "/sdcard/work/";
  // final directory = await getExternalStorageDirectory();
  final file = File('${directory}test.txt');
  String data = await file.readAsString();
  return data;
}

void _createFolder() async {
  // Uygulamanın belgeler dizini alınır
  // final directory = await getApplicationDocumentsDirectory();

  // Yeni bir klasör adı belirlenir
  final folderName = 'work';

  // Klasörün yolu oluşturulur
  final folderPath = '${"/sdcard/"}$folderName';

  // Klasör kontrol edilir ve yoksa oluşturulur
  final folder = Directory(folderPath);
  if (!folder.existsSync()) {
    folder.createSync(recursive: true);
    print('Klasör oluşturuldu: $folderPath');
  } else {
    print('Klasör zaten var: $folderPath');
  }
}
