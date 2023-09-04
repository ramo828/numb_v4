import 'package:number_seller/pages/login_page.dart';
import 'package:number_seller/pages/number_/background/network.dart';
import 'package:number_seller/pages/number_/background/work_functions.dart';
import 'package:number_seller/pages/number_/models/loading_models.dart';
import 'package:number_seller/pages/number_/models/number_models.dart';
import 'package:number_seller/pages/number_/number_widgets.dart';
import 'package:number_seller/pages/number_/models/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class number_home extends StatefulWidget {
  const number_home({super.key});

  @override
  State<number_home> createState() => _number_homeState();
}

class _number_homeState extends State<number_home> {
  bool isLoad = false;
  int operatorChoise = 0;
  List<String> getData = [];
  String numberValue = "";
  final TextEditingController _numberInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final selectedOperator = Provider.of<OperatorProvider>(context);
    final loading = Provider.of<LoadingProvider>(context);

    return Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
            toolbarHeight: 65,
            centerTitle: true,
            actions: [
              theme(themeNotifier),
            ],
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Number Seller',
                style: TextStyle(
                    fontFamily: 'Handwriting',
                    fontSize: 30,
                    color: themeNotifier.isDark
                        ? Colors.brown.withOpacity(0.9)
                        : Colors.blueGrey),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.brown.shade200.withOpacity(0.4),
                borderRadius:
                    BorderRadius.circular(20), // Yuvarlak köşeler için
              ),
              child: ListView(
                children: [
                  loading.load
                      ? const LinearProgressIndicator()
                      : const Center(),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 110,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.brown.shade200.withOpacity(0.4),
                        borderRadius:
                            BorderRadius.circular(20), // Yuvarlak köşeler için
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9xX]')),
                          ],
                          controller: _numberInputController,
                          maxLength: 7,
                          decoration: const InputDecoration(
                            enabledBorder: underlineInputBorder,
                            focusedBorder: underlineInputBorder,
                            // Çizgiyi şeffaf yapar
                            hintText: 'XXX-XX-XX',
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 260,
                      // width: 100,
                      decoration: BoxDecoration(
                        color: Colors.brown.shade200.withOpacity(0.4),
                        borderRadius:
                            BorderRadius.circular(20), // Yuvarlak köşeler için
                      ),
                      child: const myDropCollections(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.brown.shade200.withOpacity(0.4),
                        borderRadius:
                            BorderRadius.circular(20), // Yuvarlak köşeler için
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                              onPressed: () async {
                                List<String> pref =
                                    await getStringList('addPrefix');
                                print(pref);
                                Network net = Network(context: context);
                                net.getData(
                                  _numberInputController.text,
                                  selectedOperator.selectedOperator,
                                  selectedOperator.selectedPrefix,
                                  selectedOperator.selectedCategory,
                                  selectedOperator.selectedFileType,
                                  pref,
                                );
                              },
                              child: const Center(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    Text("Axtar"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          loading.okay
                              ? OutlinedButton(
                                  onPressed: () async {
                                    String filePath = '';
                                    if (selectedOperator.selectedFileType
                                        .contains("Text")) {
                                      filePath = '/sdcard/work/numberList.txt';
                                    } else if (selectedOperator
                                            .selectedFileType ==
                                        "VCF") {
                                      filePath = '/sdcard/work/contact.vcf';
                                    } else if (selectedOperator
                                            .selectedFileType ==
                                        "VCF(Zip)") {
                                      filePath = '/sdcard/work/contact.vcf.zip';
                                    }
                                    print(selectedOperator.selectedFileType);
                                    final result = await Share.shareXFiles(
                                      <XFile>[XFile(filePath)],
                                      text: 'RamoSoft',
                                      subject: 'Nömrələr',
                                    );

                                    if (result.status ==
                                        ShareResultStatus.success) {
                                      print(
                                          'Thank you for sharing the picture!');
                                    }
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.share,
                                        color: Colors.blue,
                                      ),
                                      Text("Paylaş"),
                                    ],
                                  ),
                                )
                              : const Text(''),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
