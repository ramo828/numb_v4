import 'package:flutter/material.dart';
import 'package:number_seller/pages/active_/active_widgets.dart';
import 'package:number_seller/pages/active_/helper_function.dart';
import 'package:number_seller/pages/number_/background/file_io.dart';
import 'package:number_seller/pages/number_/background/work_functions.dart';

class active_page extends StatefulWidget {
  const active_page({super.key});

  @override
  State<active_page> createState() => _active_pageState();
}

class _active_pageState extends State<active_page> {
  double _progress = 0.0; // İlerleme değeri
  int numberLength = 0;
  List<String> numbers = [];
  int max = 1000;
  bool isActive = true;
  Duration difference = Duration();
  String numberStr = "";
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Tapılan nömrə sayı: $numberLength"),
        Text(
            'İlərləmə: ${((_progress / max) * 100.0).toInt()}%'), // İlerleme değerini göster
        isActive ? Text("Keçən zaman: $difference") : Center(),
        isActive ? Text("$counter") : Center(),

        Container(
          width: 260,
          height: 20,
          child: RoundedProgressBar(
              progressColor: Colors.brown,
              height: 2.5,
              value: _progress / max,
              backgroundColor: Colors.brown.shade800.withOpacity(0.2)),
        ),
        OutlinedButton(
          onPressed: isActive
              ? () async {
                  final startTime =
                      DateTime.now(); // İşlem başlama zamanını kaydet

                  isActive = false;
                  for (int numberNumb = 0; numberNumb < 1000; numberNumb++) {
                    var data =
                        await loadNumberData(formatNumber(numberNumb), context);
                    if (data.isEmpty) {
                      showSnackBar(context, "Datalar Yüklənmədi", 2);
                      // break;
                    }
                    numbers.addAll(data);
                    setState(() {
                      numberLength = numbers.length;
                      _progress++;
                    });
                  }
                  isActive = true;
                  for (String numb in numbers) {
                    numberStr = "$numb\n";
                    setState(() {
                      counter++;
                    });
                  }
                  await writeData(numberStr, "allData");

                  final endTime = DateTime.now(); // İşlem bitiş zamanını kaydet
                  setState(() {
                    difference =
                        endTime.difference(startTime); // Süreyi hesaplayın
                  });
                }
              : null,
          child: Text("Yüklə"),
        ),
      ],
    );
  }
}
