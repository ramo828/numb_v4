import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:number_seller/pages/active_numbers/active_numb.dart';
import 'package:number_seller/pages/number_/backend/file_io.dart';

class active_number extends StatefulWidget {
  const active_number({super.key});

  @override
  State<active_number> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<active_number> {
  @override
  String _filePath = '';
  String data = "";
  String num = "";
  String prefix = "";

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
      });
    }
  }

  Widget build(BuildContext context) {
    return ListView(
      children: [
        OutlinedButton(
          onPressed: () {
            _openFilePicker();
          },
          child: Text("Fayl sec"),
        ),
        OutlinedButton(
            onPressed: () async {
              activeNetwork an = activeNetwork();
              // data = await readData(_filePath);
              // for (String number in data.split("\n")) {
              //   if (number.isNotEmpty) {
              //     print(await an.activeNUmbersBakcell(
              //       number.substring(2),
              //       number.substring(0, 2),
              //     ));
              //   }
              // }
              print(await an.activeNUmbersBakcell("8302766", "55"));
            },
            child: Text("Axtar"))
      ],
    );
  }
}
