import 'dart:io';

Future<void> writeData(String data, String filename) async {
  // final directory =
  //     await getExternalStorageDirectory(); // Cihazın dış hafızasına erişim sağlar
  _createFolder();
  const directory = "/sdcard/work/";
  final file = File('$directory$filename');
  if (file.existsSync()) {
    new File('$directory$filename').create(recursive: true);
  }

  await file.writeAsString(data);
}

Future<String> readData() async {
  const directory = "/sdcard/work/";
  // final directory = await getExternalStorageDirectory();
  final file = File('${directory}test.txt');
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
