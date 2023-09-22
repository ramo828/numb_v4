import 'package:flutter/material.dart';
import 'package:number_seller/pages/active_/active_widgets.dart';
import 'package:number_seller/pages/active_/helper_function.dart';
import 'package:number_seller/pages/number_/background/file_io.dart';
import 'package:number_seller/pages/number_/background/work_functions.dart';
import 'package:number_seller/pages/number_/models/active_model.dart';
import 'package:number_seller/pages/number_/number_widgets.dart';
import 'package:provider/provider.dart';

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
  Duration difference = const Duration();
  String numberStr = "";
  int counter = 0;
  int errCount = 0;
  bool emergencyStop = false;
  bool startStatus = false;
  int statusOperation = 0;

  @override
  Widget build(BuildContext context) {
    final selectedActive = Provider.of<ActiveProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomDropdownButton(
            dropName: "Əməliyyat",
            dropdownValue: defaultOperation,
            items: operation,
            onChanged: (String? newValue) {
              selectedActive.updateSelectedOperation(newValue!);
              setState(() {
                if (newValue.contains("Köhnə")) {
                  statusOperation = 0;
                } else if (newValue.contains("Yeni")) {
                  statusOperation = 1;
                }
                defaultOperation = newValue;
                selectedActive.updateSelectedOperation(defaultOperation);
              });
            }),
        CustomDropdownButton(
            dropName: "Operator",
            dropdownValue: defaultOperator,
            items: operators,
            onChanged: (String? newValue) {
              selectedActive.updateSelectedOperator(newValue!);
              setState(() {
                defaultOperator = newValue;
                if (defaultOperator.contains("Bakcell")) {
                  defaultPrefix = "055";
                } else {
                  defaultPrefix = "070";
                }
                selectedActive.updateSelectedPrefix(defaultPrefix);
              });
            }),
        CustomDropdownButton(
            dropName: "Prefix",
            dropdownValue: defaultPrefix,
            items:
                defaultOperator.contains("Bakcell") ? prefixBakcell : prefixNar,
            onChanged: (String? newValue) {
              selectedActive.updateSelectedPrefix(newValue!);
              setState(() {
                defaultPrefix = newValue;
                defaultCategory = "Hamısı";
              });
            }),
        const SizedBox(
          height: 15,
        ),
        Text(
          "Tapılan nömrə sayı: $numberLength",
          style: const TextStyle(fontFamily: 'Lobster', fontSize: 17),
        ),
        Text(
          'Yüklənib: ${((_progress / max) * 100.0).toInt()}%',
          style: const TextStyle(fontFamily: 'Lobster', fontSize: 17),
        ), // İlerleme değerini göster
        isActive
            ? Text(
                "Keçən zaman: $difference",
                style: const TextStyle(fontFamily: 'Lobster', fontSize: 17),
              )
            : const Center(),
        isActive
            ? Text(
                "Sıra: $counter",
                style: const TextStyle(fontFamily: 'Lobster', fontSize: 17),
              )
            : const Center(),

        !isActive
            ? SizedBox(
                width: 260,
                height: 20,
                child: RoundedProgressBar(
                    progressColor: Colors.brown,
                    height: 2.5,
                    value: _progress / max,
                    backgroundColor: Colors.brown.shade800.withOpacity(0.2)),
              )
            : const Center(),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: isActive
                  ? () async {
                      setState(() {
                        numbers.clear();
                        emergencyStop = false;
                      });

                      final startTime =
                          DateTime.now(); // İşlem başlama zamanını kaydet
                      startStatus = true;
                      isActive = false;
                      for (int numberNumb = 0;
                          numberNumb < 1000;
                          numberNumb++) {
                        if (emergencyStop) break;
                        var data = await loadNumberData(
                            formatNumber(numberNumb), context);
                        if (data.isEmpty) {
                          errCount++;
                        }
                        if (errCount > 50) {
                          showSnackBar(context, "Datalar Yüklənmədi", 2);
                          break;
                        }
                        numbers.addAll(data);
                        setState(() {
                          numberLength = numbers.length;
                          _progress++;
                        });
                      }
                      isActive = true;
                      for (String numb in numbers) {
                        numberStr += "$numb\n";
                        setState(() {
                          counter++;
                        });
                      }
                      if (statusOperation == 0) {
                        await writeData(numberStr, "oldData");
                      } else if (statusOperation == 1) {
                        await writeData(numberStr, "newData");
                      } else {}
                      startStatus = false;
                      final endTime =
                          DateTime.now(); // İşlem bitiş zamanını kaydet
                      setState(() {
                        difference =
                            endTime.difference(startTime); // Süreyi hesaplayın
                      });
                    }
                  : null,
              child: const Icon(
                Icons.play_arrow,
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            OutlinedButton(
                onPressed: !isActive
                    ? () {
                        setState(() {
                          if (startStatus) {
                            emergencyStop = true;
                            numberStr = "";
                            _progress = 0.0;
                            errCount = 0;
                          }
                        });
                      }
                    : null,
                child: const Icon(
                  Icons.stop,
                  color: Colors.red,
                ))
          ],
        ),
      ],
    );
  }
}
