import 'package:flutter/material.dart';
import 'package:number_seller/pages/active_/active_widgets.dart';
import 'package:number_seller/pages/active_/helper_function.dart';
import 'package:number_seller/pages/number_/background/file_io.dart';
import 'package:number_seller/pages/number_/background/work_functions.dart';
import 'package:number_seller/pages/number_/models/active_model.dart';
import 'package:number_seller/pages/number_/number_widgets.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class active_page extends StatefulWidget {
  final level;
  const active_page({
    super.key,
    required this.level,
  });

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
  bool dataLoad = true;
  bool calculateStatus = false;
  bool test = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Uygulama başladığında ekranın uyumamasını etkinleştir
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    // Sayfa kapatıldığında ekranın uyumamasını devre dışı bırak
    WakelockPlus.disable();
    super.dispose();
  }

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
                  dataLoad = true;
                } else if (newValue.contains("Yeni")) {
                  statusOperation = 1;
                  dataLoad = true;
                } else {
                  dataLoad = false;
                }
                defaultOperation = newValue;
                selectedActive.updateSelectedOperation(defaultOperation);
              });
            }),
        CustomDropdownButton(
            dropName: "Operator",
            dropdownValue: defaultOperator1,
            items: operators1,
            disableItem: (widget.level > 2) ? "" : "Bakcell",
            onChanged: (String? newValue) {
              selectedActive.updateSelectedOperator(newValue!);
              setState(() {
                defaultOperator1 = newValue;
                if (defaultOperator1.contains("Nar")) {
                  defaultPrefix1 = "070";
                } else {
                  defaultPrefix1 = "077";
                }
                selectedActive.updateSelectedPrefix(defaultPrefix);
              });
            }),
        CustomDropdownButton(
            dropName: "Prefix",
            dropdownValue: defaultPrefix1,
            items: defaultOperator1.contains("Bakcell")
                ? prefixBakcell
                : prefixNar,
            onChanged: (String? newValue) {
              selectedActive.updateSelectedPrefix(newValue!);
              setState(() {
                defaultPrefix1 = newValue;
                // defaultCategory = "Hamısı";
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
        isActive && dataLoad
            ? Text(
                "Keçən zaman: $difference",
                style: const TextStyle(fontFamily: 'Lobster', fontSize: 17),
              )
            : const Center(),

        !dataLoad
            ? Text(
                calculateStatus ? "Hesablanır" : "Hesablandı",
                style: TextStyle(
                    fontFamily: 'Lobster',
                    fontSize: 17,
                    color: calculateStatus ? Colors.pink : Colors.green),
              )
            : const Center(),
        test
            ? Text(
                test ? "Yazılır $counter" : "Yazıldı $counter",
                style: TextStyle(
                    fontFamily: 'Lobster',
                    fontSize: 17,
                    color: test ? Colors.pink : Colors.green),
              )
            : Center(),

        !isActive || !dataLoad
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
        test
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(),
              )
            : Center(),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: isActive
                  ? () async {
                      if (dataLoad) {
                        WakelockPlus.enable();

                        setState(() {
                          numbers.clear();
                          emergencyStop = false;
                          numberStr = "";
                          _progress = 0.0;
                          errCount = 0;
                          counter = 0;
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
                            // ignore: use_build_context_synchronously
                            showSnackBar(context, "Datalar Yüklənmədi", 2);
                            break;
                          }
                          numbers.addAll(data);
                          setState(() {
                            numberLength = numbers.length;
                            _progress++;
                          });
                        }

                        if (statusOperation == 0) {
                          isActive = true;
                          setState(() {
                            test = true;
                          });
                          await writeToDisk(numbers, "oldData");

                          setState(() {
                            test = false;
                          });
                        } else if (statusOperation == 1) {
                          isActive = true;
                          setState(() {
                            test = true;
                          });
                          await writeToDisk(numbers, "newData");

                          setState(() {
                            test = false;
                          });
                        }
                        startStatus = false;
                        final endTime =
                            DateTime.now(); // İşlem bitiş zamanını kaydet
                        setState(() {
                          difference = endTime
                              .difference(startTime); // Süreyi hesaplayın
                        });
                        WakelockPlus.disable();
                      } else {
                        // Calculate
                        WakelockPlus.enable();
                        await calcProcessing();
                        setState(() {
                          calculateStatus = false;
                          isActive = true;
                          startStatus = false;
                        });
                        WakelockPlus.disable();
                      }
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
                      numbers.clear();
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
              ),
            )
          ],
        ),
      ],
    );
  }

  Future<void> calcProcessing() async {
    Set<String> missingItems = Set<String>();
    List<String> nData = splitStringByNewline(await readData("newData"));
    setState(() {
      calculateStatus = true;
      _progress = 0;
      max = nData.length;
      numberStr = "";
      startStatus = true;
      numberLength = 0;
    });
    Set<String> oData =
        Set<String>.from(splitStringByNewline(await readData("oldData")));
    for (var item1 in nData) {
      if (!oData.contains(item1)) {
        missingItems.add(item1);
        setState(() {
          numberLength++;
        });
        await Future.delayed(Duration.zero);
      }
      setState(() {
        _progress++;
      });
    }
    writeToDisk(missingItems.toList(), "yeni_nomreler.txt");
  }
}
