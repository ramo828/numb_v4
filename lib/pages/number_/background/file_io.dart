import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:number_seller/main.dart';
import 'package:path_provider/path_provider.dart';

// final directory =
//     await getExternalStorageDirectory(); // Cihazın dış hafızasına erişim sağlar
const directory = "/sdcard/work/";

void ls(String folderPath) {
  final directory = Directory(folderPath);
  if (directory.existsSync()) {
    final contents = directory.listSync();
    for (final item in contents) {
      print(item.path); // Öğenin yolunu yazdırın
    }
  } else {
    print("Klasör bulunamadı: $folderPath");
  }
}

Future<void> writeData(String data, String filename) async {
  _createFolder();

  try {
    final file = File(directory + filename);

    // file.deleteSync(); // Dosyayı senkron olarak sil
    // print('Dosya başarıyla silindi');
    if (file.existsSync()) {
      // File('$directory$filename').create(recursive: true);
      File(directory + filename).create(recursive: true);
    }

    await file.writeAsString(data);
  } catch (e) {
    print('Bir xəta baş verdi: $e');
    logger.e('Bir xəta baş verdi: $e');
  }
}

Future<void> writeToDisk(List<String> data, String dosyaYolu) async {
  final String contents = data.join('\n');
  try {
    Directory appDocDir = Directory(dosyaYolu);
    final File file = File(appDocDir.path);
    if (file.existsSync()) {
      file.deleteSync(); // Dosyayı senkron olarak sil
    }
    await compute(
      (String dosyaIcerigi) => saveData(dosyaIcerigi, dosyaYolu),
      contents,
    );
    print('Veri diske yazıldı.');
    logger.i("Veri diske yazıldı.");
  } catch (e) {
    logger.e('Hata oluştu: $e');
    Exception(e);
    // Hata durumuna nasıl yanıt vermek istediğinizi burada belirleyebilirsiniz.
  }
}

Future<void> saveData(String data, String dosyaYolu) async {
  try {
    Directory appDocDir = Directory(dosyaYolu);

    final File file = File(appDocDir.path);

    file.writeAsStringSync(data.replaceAll('\n\n', '\n'),
        mode: FileMode.append); // Verileri dosyaya yazın.
  } catch (e) {
    print(e);
    logger.e(e);
    Exception(e);
  }
}

Future<String> readData(String fileName) async {
  try {
    ls(fileName);
    final file = File(fileName);

    if (await file.exists()) {
      // Dosyanın varlığını kontrol edin
      String data = await file.readAsString();
      return data;
    } else {
      print("Fayl tapilmadi: $file");
      return "Fayl yoxdu";
    }
  } catch (e) {
    Exception(e);
    return "Fayl yoxdu";
  }
}

void _createFolder() async {
  // Uygulamanın belgeler dizini alınır
  // final directory = await getApplicationDocumentsDirectory();

  // Yeni bir klasör adı belirlenir
  // const folderName = 'work';

  // Klasörün yolu oluşturulur
  const folderPath = directory;

  // Klasör kontrol edilir ve yoksa oluşturulur
  final folder = Directory(folderPath);
  if (!folder.existsSync()) {
    folder.createSync(recursive: true);
    print('Klasör oluşturuldu: $folderPath');
    logger.i("Klasör oluşturuldu: $folderPath");
  } else {
    print('Klasör zaten var: $folderPath');
    logger.i("Klasör zaten var: $folderPath");
  }
}

Future<bool> doesFileExist(String filePath) async {
  List<Directory>? path = await getExternalStorageDirectories();
  File file = File(path![0].path + filePath);
  return await file.exists();
}

Future<bool> deleteFile(String filePath) async {
  try {
    List<Directory>? path = await getExternalStorageDirectories();
    File file = File(path![0].path + filePath);
    await file.delete();
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> changeFileName(String oldFileName, String newFileName) async {
  try {
    List<Directory>? path = await getExternalStorageDirectories();

    File oldFile = File('${path![0].path}/$oldFileName');
    String directory = oldFile.parent.path;
    String newFilePath = '$directory/$newFileName';

    oldFile.renameSync(newFilePath);

    print('Dosyanın adı değiştirildi: $newFilePath');
    return true;
  } catch (e) {
    print('Dosya adı değiştirilemedi: $e');
    return false;
  }
}
