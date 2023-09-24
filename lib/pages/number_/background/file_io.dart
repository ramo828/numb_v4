import 'dart:io';
import 'package:flutter/foundation.dart';

Future<void> writeData(String data, String filename) async {
  // final directory =
  //     await getExternalStorageDirectory(); // Cihazın dış hafızasına erişim sağlar
  _createFolder();

  try {
    const directory = "/sdcard/work/";
    final file = File('$directory$filename');
    // file.deleteSync(); // Dosyayı senkron olarak sil
    // print('Dosya başarıyla silindi');
    if (file.existsSync()) {
      File('$directory$filename').create(recursive: true);
    }

    await file.writeAsString(data);
  } catch (e) {
    print('Bir xəta baş verdi: $e');
  }
}

Future<void> writeToDisk(List<String> data, String dosyaYolu) async {
  final String contents =
      data.join('\n'); // Verileri yeni satırlarla birleştirin.
  await compute(
      (String dosyaIcerigi) => saveData(dosyaIcerigi, dosyaYolu), contents);
}

void saveData(String data, String dosyaYolu) {
  final File file = File('/sdcard/work/$dosyaYolu');
  if (file.existsSync()) {
    file.deleteSync(); // Dosyayı senkron olarak sil
  }
  file.writeAsStringSync(data.replaceAll('\n\n', '\n'),
      mode: FileMode.append); // Verileri dosyaya yazın.
}

Future<String> readData(String fileName) async {
  const directory = "/sdcard/work/";
  // final directory = await getExternalStorageDirectory();
  final file = File('$directory$fileName');
  String data = await file.readAsString();
  return data;
}

void _createFolder() async {
  // Uygulamanın belgeler dizini alınır
  // final directory = await getApplicationDocumentsDirectory();

  // Yeni bir klasör adı belirlenir
  const folderName = 'work';

  // Klasörün yolu oluşturulur
  const folderPath = '${"/sdcard/"}$folderName';

  // Klasör kontrol edilir ve yoksa oluşturulur
  final folder = Directory(folderPath);
  if (!folder.existsSync()) {
    folder.createSync(recursive: true);
    print('Klasör oluşturuldu: $folderPath');
  } else {
    print('Klasör zaten var: $folderPath');
  }
}
