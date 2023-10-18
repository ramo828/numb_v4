import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:number_seller/main.dart';
import 'package:number_seller/pages/active_/active_widgets.dart';
import 'package:number_seller/pages/active_/helper_function.dart';
import 'package:number_seller/pages/active_/numberList_page.dart';
import 'package:number_seller/pages/login_page.dart';
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
  String manualNumber = "";
  bool isCheckedManual = false;
  String changePrefix = "070";
  bool deleteStatus = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Uygulama başladığında ekranın uyumamasını etkinleştir
    WakelockPlus.enable();
    loadPath();
    manualNumberListLoad();
  }

  @override
  void dispose() {
    // Sayfa kapatıldığında ekranın uyumamasını devre dışı bırak
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> manualNumberListLoad() async {
    List dataL = await getStringList('manualNumberList');
    if (dataL.isNotEmpty) {
      for (String numData in dataL) {
        manualNumber += "$numData\n";
      }
    }
  }

  void loadPath() async {
    cacheDirs = (await getExternalStorageDirectories())!;
    cacheDir = cacheDirs[0];
  }

  @override
  Widget build(BuildContext context) {
    final selectedActive = Provider.of<ActiveProvider>(context);
    TextEditingController tec = TextEditingController(text: manualNumber);

    return ListView(
      children: [
        FutureBuilder<List<bool>>(
          future: Future.wait([
            doesFileExist("/oldData.${selectedActive.selectedPrefix}"),
            doesFileExist("/newData.${selectedActive.selectedPrefix}"),
          ]),
          builder: (BuildContext context, AsyncSnapshot<List<bool>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Hata: ${snapshot.error}');
            } else {
              final List<bool> fileExists = snapshot.data!;
              fileDetector[0] = fileExists[0];
              fileDetector[1] = fileExists[1];

              return Center(
                child: Card(
                  color: darkTheme ? Colors.brown.shade100 : Colors.black38,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 140),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Yeni baza ($changePrefix): "),
                            Icon(
                              fileDetector[1] ? Icons.check : Icons.cancel,
                              color:
                                  fileDetector[1] ? Colors.green : Colors.red,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text("Köhnə baza ($changePrefix): "),
                            Icon(
                              fileDetector[0] ? Icons.check : Icons.cancel,
                              color:
                                  fileDetector[0] ? Colors.green : Colors.red,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
        PopupMenuButton<String>(
          color: Colors.brown.shade100.withOpacity(0.9),
          icon: Card(
            color: darkTheme
                ? Colors.brown.shade100.withOpacity(0.9)
                : Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isCheckedManual,
                  onChanged: (newValue) {
                    setState(() {
                      isCheckedManual = newValue!;
                    });
                  },
                ),
                const Icon(
                  FontAwesomeIcons.pen,
                  color: Colors.black54,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("Əl ilə yaz")
              ],
            ),
          ),
          onSelected: (String choice) async {
            if (choice == 'save') {
              await saveStringList('manualNumberList', tec.text.split('\n'));
              setState(() {
                manualNumber = tec.text;
              });
            }
          },
          itemBuilder: (BuildContext context) {
            // Popup menü öğelerini burada oluşturun.
            return <PopupMenuEntry<String>>[
              // Sadece bir TextField eklemek için aşağıdaki satırı kullanın.
              isCheckedManual
                  ? PopupMenuItem<String>(
                      value: 'Nömrələr',
                      child: SingleChildScrollView(
                        child: TextField(
                          controller: tec,
                          minLines: 7,
                          decoration: const InputDecoration(
                            hintText: 'xxxxxxx',
                            hintMaxLines: 7,
                          ),
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onChanged: (val) {
                            print(val);
                          },
                        ),
                      ),
                    )
                  : const PopupMenuItem<String>(
                      child: Text("Passiv"),
                    ),
              isCheckedManual
                  ? const PopupMenuItem<String>(
                      value: 'save',
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            Icon(
                              Icons.save,
                            ),
                            Spacer(),
                            Text("Qeyd et"),
                          ],
                        ),
                      ),
                    )
                  : const PopupMenuItem<String>(
                      child: Center(),
                    ),
            ];
          },
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
            enableStatus: !isCheckedManual,
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
            enableStatus: !selectCalculateStatus && (!isCheckedManual || false),
            dropName: "Prefix",
            dropdownValue: defaultPrefix1,
            items: defaultOperator1.contains("Bakcell")
                ? prefixBakcell1
                : prefixNar1,
            onChanged: (String? newValue) {
              selectedActive.updateSelectedPrefix(newValue!);
              setState(() {
                changePrefix = newValue;
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
        Tooltip(
          message: 'Yeni nömrələr tapıldıqdan sonra köhnə nömrələri sil',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Wrap(children: [
                Text(
                  "Köhnə nömrələri sil",
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.grey,
                    fontFamily: "Lobster",
                    fontWeight: FontWeight.bold,
                  ), // Yazı tipi boyutunu ayarlayın
                ),
              ]),
              Checkbox(
                value: deleteStatus,
                onChanged: selectCalculateStatus
                    ? (value) {
                        setState(() {
                          if (deleteStatus) {
                            deleteStatus = false;
                          } else {
                            deleteStatus = true;
                          }
                        });
                      }
                    : null,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Card(
          color: !darkTheme
              ? Colors.black26.withOpacity(0.7)
              : Colors.brown.shade50.withOpacity(0.7),
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
                              if (!isCheckedManual) {
                                for (int numberNumb = 0;
                                    numberNumb < max;
                                    numberNumb++) {
                                  if (emergencyStop) break;
                                  // ignore: use_build_context_synchronously
                                  var data = await loadNumberData(
                                      "xxxx${formatNumber(numberNumb)}",
                                      context);
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
                              } else {
                                for (String numberNumb in manualNumber
                                    .substring(0, manualNumber.length - 1)
                                    .split('\n')) {
                                  if (numberNumb.length == 9) {
                                    selectedActive.updateSelectedPrefix(
                                        numberNumb.substring(0, 2));
                                    numberNumb = numberNumb.substring(
                                        2, numberNumb.length);
                                  }
                                  if (emergencyStop) break;
                                  // ignore: use_build_context_synchronously
                                  var data =
                                      await loadNumberData(numberNumb, context);
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
                                    max = manualNumber.split("\n").length;
                                    _progress++;
                                    startStatus = true;
                                    isActive = false;
                                  });
                                }
                              }
                              if (statusOperation == 0) {
                                isActive = true;
                                setState(() {
                                  test = true;
                                });
                                await writeToDisk(numbers,
                                    "${cacheDir.path}/oldData.${selectedActive.selectedPrefix}");
                                setState(() {
                                  test = false;
                                });
                              } else if (statusOperation == 1) {
                                isActive = true;
                                setState(() {
                                  test = true;
                                });
                                await writeToDisk(numbers,
                                    "${cacheDir.path}/newData.${selectedActive.selectedPrefix}");
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
                              } else if (statusOperation == 1) {}
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
                            // ignore: use_build_context_synchronously
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
                      color: darkTheme
                          ? Colors.brown.shade100.withOpacity(0.9)
                          : Colors.transparent,
                      child: PopupMenuButton<String>(
                        color: darkTheme
                            ? Colors.brown.shade100.withOpacity(0.9)
                            : Colors.black45,
                        icon: Icon(
                          FontAwesomeIcons.gears,
                          color: darkTheme ? Colors.black54 : Colors.white,
                        ),
                        onSelected: (String choice) async {
                          // Popup menüden seçilen öğeyi işleme alabilirsiniz.
                          if (choice == 'clear') {
                            if (await deleteFile(
                                    '/oldData.${selectedActive.selectedPrefix}') ||
                                await deleteFile(
                                    '/newData.${selectedActive.selectedPrefix}')) {
                              setState(() {
                                ls(cacheDir.path);
                              });
                              // ignore: use_build_context_synchronously
                              showSnackBar(context, "Bazalar silindi", 2);
                            } else {
                              // ignore: use_build_context_synchronously
                              showSnackBar(
                                  context,
                                  "Bazalar silinmedi. Buna səbəb bazaların tamamının və ya birinin yüklü olmaması ola bilər",
                                  2);
                            }
                          } else if (choice == 'rename') {
                            await deleteFile('/oldData');
                            Future.delayed(const Duration(microseconds: 100));
                            if (await changeFileName(
                                "newData.${selectedActive.selectedPrefix}",
                                "oldData.${selectedActive.selectedPrefix}")) {
                              // ignore: use_build_context_synchronously
                              showSnackBar(context,
                                  "Yeni baza köhnə bazaya dəyişdirildi", 2);
                            } else {
                              // ignore: use_build_context_synchronously
                              showSnackBar(
                                  context,
                                  "Yeni baza köhnə bazaya dəyişdirilə bilmədi\nBuna səbəb yeni bazanın yüklənməmiş olması və ya daha öncədən dəyişdirilməsi ola bilər.",
                                  5);
                            }
                            Future.delayed(const Duration(microseconds: 100));
                          } else if (choice == "show") {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MyDataTable(),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MyDataTable(allData: true),
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
                                  Text(
                                    'Yeni nömrələr',
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'all_show',
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.clockRotateLeft),
                                  Spacer(),
                                  Text(
                                    'Bütün nömrələr',
                                    maxLines: 3,
                                  ),
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
                            // ignore: use_build_context_synchronously
                            showSnackBar(context, e.toString(), 4);
                            // ignore: avoid_print
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
          ],
        ),
      ],
    );
  }

  Future<void> calcProcessing() async {
    final selectedActive = Provider.of<ActiveProvider>(context, listen: false);

    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    user = auth.currentUser;
    try {
      ls(cacheDir.path);
      Set<String> missingItems = <String>{};
      FirebaseFunctions f = FirebaseFunctions();

      List<String> nData = splitStringByNewline(await readData(
          "${cacheDir.path}/newData.${selectedActive.selectedPrefix}"));
      setState(() {
        calculateStatus = true;
        _progress = 0;
        max = nData.length;
        numberStr = "";
        startStatus = true;
        numberLength = 0;
      });
      Set<String> oData = Set<String>.from(splitStringByNewline(await readData(
          "${cacheDir.path}/oldData.${selectedActive.selectedPrefix}")));
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
      if (missingItems.isNotEmpty && deleteStatus) {
        f.clearListField(
            "users", user!.uid, selectedActive.selectedOperator.toLowerCase());
      }

      await f.compareAndAddList(missingItems.toList(), operator.toLowerCase());
      await f.compareAndAddListUser(
          missingItems.toList(), operator.toLowerCase());
      await writeToDisk(
          missingItems.toList(), "${cacheDir.path}/yeni_nomreler.txt");
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString(), 4);
    }
  }
}
