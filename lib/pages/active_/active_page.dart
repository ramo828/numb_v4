import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:number_seller/main.dart';
import 'package:number_seller/pages/active_/active_widgets.dart';
import 'package:number_seller/pages/active_/helper_function.dart';
import 'package:number_seller/pages/active_/numberList_page.dart';
import 'package:number_seller/pages/number_/background/file_io.dart';
import 'package:number_seller/pages/number_/background/work_functions.dart';
import 'package:number_seller/pages/number_/models/active_model.dart';
import 'package:number_seller/pages/number_/number_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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
  bool selectCalculateStatus = false;
  bool test = false;
  bool shareStatus = false;
  Directory cacheDir = Directory('');
  List<Directory> cacheDirs = [];
  String operator = "Nar";
  List<bool> fileDetector = [false, false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Uygulama başladığında ekranın uyumamasını etkinleştir
    WakelockPlus.enable();
    loadPath();
    fileDetectorFunction();
  }

  @override
  void dispose() {
    // Sayfa kapatıldığında ekranın uyumamasını devre dışı bırak
    WakelockPlus.disable();
    super.dispose();
  }

  void loadPath() async {
    cacheDirs = (await getExternalStorageDirectories())!;
    cacheDir = cacheDirs[0];
  }

  void fileDetectorFunction() async {
    bool oldDataStatus = await doesFileExist("/oldData");
    bool newDataStatus = await doesFileExist("/newData");
    setState(() {
      fileDetector[0] = oldDataStatus;
      fileDetector[1] = newDataStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedActive = Provider.of<ActiveProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: Colors.brown.shade100,
          child: Padding(
            padding: const EdgeInsets.only(left: 140),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Yeni baza: "),
                    Icon(
                      fileDetector[1] ? Icons.check : Icons.cancel,
                      color: fileDetector[1] ? Colors.green : Colors.red,
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("Köhnə baza: "),
                    Icon(
                      fileDetector[0] ? Icons.check : Icons.cancel,
                      color: fileDetector[0] ? Colors.green : Colors.red,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
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
                  selectCalculateStatus = false;
                } else if (newValue.contains("Yeni")) {
                  statusOperation = 1;
                  dataLoad = true;
                  selectCalculateStatus = false;
                } else {
                  dataLoad = false;
                  selectCalculateStatus = true;
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
                  defaultPrefix1 = "055";
                }
                selectedActive.updateSelectedPrefix(defaultPrefix1);
                operator = newValue.toString();
              });
            }),
        CustomDropdownButton(
            enableStatus: !selectCalculateStatus,
            dropName: "Prefix",
            dropdownValue: defaultPrefix1,
            items: defaultOperator1.contains("Bakcell")
                ? prefixBakcell1
                : prefixNar1,
            onChanged: (String? newValue) {
              selectedActive.updateSelectedPrefix(newValue!);
              setState(() {
                defaultPrefix1 = newValue;
                // defaultCategory = "Hamısı";
              });
            }),
        CustomDropdownButton(
            dropName: "Kategoriya",
            enableStatus: !selectCalculateStatus,
            dropdownValue: defaultCategory1,
            disableItem: widget.level < 1 ? "Bürünc" : "",
            items: defaultPrefix1.contains("055")
                ? category0551
                : defaultPrefix.contains("099")
                    ? category0991
                    : categoryNar1,
            onChanged: (String? newValue) {
              selectedActive.updateSelectedCategory(newValue!);
              setState(() {
                defaultCategory1 = newValue;
              });
            }),
        const SizedBox(
          height: 15,
        ),
        Card(
          color: Colors.brown.shade50.withOpacity(0.7),
          child: Column(
            children: [
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
                      style:
                          const TextStyle(fontFamily: 'Lobster', fontSize: 17),
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
                  : const Center(),
            ],
          ),
        ),
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
            : const Center(),
        const SizedBox(
          height: 15,
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: isActive
                      ? () async {
                          try {
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

                              final startTime = DateTime
                                  .now(); // İşlem başlama zamanını kaydet
                              startStatus = true;
                              isActive = false;
                              for (int numberNumb = 0;
                                  numberNumb < 1000;
                                  numberNumb++) {
                                if (emergencyStop) break;
                                // ignore: use_build_context_synchronously
                                var data = await loadNumberData(
                                    formatNumber(numberNumb), context);
                                if (data.isEmpty) {
                                  errCount++;
                                }
                                if (errCount > 50) {
                                  // ignore: use_build_context_synchronously
                                  showSnackBar(
                                      context, "Datalar Yüklənmədi", 2);
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
                                await writeToDisk(
                                    numbers, "${cacheDir.path}/oldData");
                                setState(() {
                                  test = false;
                                });
                              } else if (statusOperation == 1) {
                                isActive = true;
                                setState(() {
                                  test = true;
                                });
                                await writeToDisk(
                                    numbers, "${cacheDir.path}/newData");
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
                              if (statusOperation == 0) {
                                setState(() {
                                  fileDetector[0] = true;
                                });
                              } else if (statusOperation == 1) {
                                fileDetector[1] = true;
                              }
                            } else {
                              // Calculate

                              WakelockPlus.enable();
                              setState(() {
                                shareStatus = false;
                                isActive = false;
                              });
                              await calcProcessing();

                              setState(() {
                                calculateStatus = false;
                                isActive = true;
                                startStatus = false;
                                shareStatus = true;
                              });
                              WakelockPlus.disable();
                            }
                          } catch (e) {
                            logger.e(e);
                            showSnackBar(context, e.toString(), 3);
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 48,
                    width: 70,
                    child: Card(
                      color: Colors.brown.shade100,
                      child: PopupMenuButton<String>(
                        color: Colors.brown.shade100.withOpacity(0.9),
                        icon: const Icon(
                          FontAwesomeIcons.gears,
                          color: Colors.black54,
                        ),
                        onSelected: (String choice) async {
                          // Popup menüden seçilen öğeyi işleme alabilirsiniz.
                          if (choice == 'clear') {
                            if (await deleteFile('/oldData') ||
                                await deleteFile('/newData')) {
                              setState(() {
                                ls(cacheDir.path);
                                fileDetector[0] = false;
                                fileDetector[1] = false;
                              });
                              showSnackBar(context, "Bazalar silindi", 2);
                            } else {
                              showSnackBar(context, "Bazalar silinmedi", 2);
                            }
                          } else if (choice == 'rename') {
                            await deleteFile('/oldData');
                            Future.delayed(const Duration(microseconds: 100));
                            changeFileName("newData", "oldData");
                            Future.delayed(const Duration(microseconds: 100));

                            setState(() {
                              fileDetector[1] = false;
                            });
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MyDataTable(),
                              ),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          // Popup menü öğelerini burada oluşturun.
                          return <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'show',
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.readme),
                                  Spacer(),
                                  Text('Göstər'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'rename',
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.recycle),
                                  Spacer(),
                                  Text('Datanı dəyiş'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'clear',
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.trash),
                                  Spacer(),
                                  Text('Bazaları sil'),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            shareStatus
                ? Column(
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          try {
                            final res = await Share.shareXFiles(
                              <XFile>[
                                XFile("${cacheDir.path}/yeni_nomreler.txt")
                              ],
                              text: 'RamoSoft',
                              subject: 'Activies',
                            );

                            if (res.status == ShareResultStatus.success) {}
                          } catch (e) {
                            logger.e(e);
                            showSnackBar(context, e.toString(), 4);
                            print(e);
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share),
                            Text(
                              "Paylaş",
                              style: TextStyle(fontFamily: 'Lobster'),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MyDataTable(),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(FontAwesomeIcons.eye),
                            ),
                            Text(
                              "Nömrələri göstər",
                              style: TextStyle(fontFamily: 'Lobster'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Center(),
            shareStatus
                ? Text(
                    "Yazıldı: ${cacheDir.path}",
                    style: const TextStyle(
                      fontFamily: "Lobster",
                      fontSize: 8,
                    ),
                  )
                : const Center(),
          ],
        ),
      ],
    );
  }

  Future<void> calcProcessing() async {
    try {
      ls(cacheDir.path);
      Set<String> missingItems = <String>{};
      FirebaseFunctions f = FirebaseFunctions();

      List<String> nData =
          splitStringByNewline(await readData("${cacheDir.path}/newData"));
      setState(() {
        calculateStatus = true;
        _progress = 0;
        max = nData.length;
        numberStr = "";
        startStatus = true;
        numberLength = 0;
      });
      Set<String> oData = Set<String>.from(
          splitStringByNewline(await readData("${cacheDir.path}/oldData")));
      for (var item1 in nData) {
        if (emergencyStop) {
          emergencyStop = false;
          break;
        }

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
      if (missingItems.isNotEmpty) await f.clearListField("numbers", 'nar');

      await f.compareAndAddList(missingItems.toList(), operator.toLowerCase());
      await writeToDisk(
          missingItems.toList(), "${cacheDir.path}/yeni_nomreler.txt");
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString(), 4);
    }
  }
}
