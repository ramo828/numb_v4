import 'dart:convert';

import 'package:e_com/pages/login_page.dart';
import 'package:e_com/pages/number_/background/number_constant.dart';
import 'package:e_com/pages/number_/background/work_functions.dart';
import 'package:e_com/pages/number_/models/number_models.dart';
import 'package:e_com/pages/number_/number_widgets.dart';
import 'package:e_com/themes/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
  List<String> getNumberValue = [];
  int numberLength = 0;

  @override
  Widget build(BuildContext context) {
    final selectedOperator = Provider.of<OperatorProvider>(context);

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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 80,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.brown.shade200.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(
                              20), // Yuvarlak köşeler için
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            enabledBorder: underlineInputBorder,
                            focusedBorder: underlineInputBorder,
                            // Çizgiyi şeffaf yapar
                            labelText: 'Nömrə',
                            hintText: 'XXX-XX-XX',
                          ),
                          initialValue: "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          inputFormatters: [ssnMaskFormatter],
                          onChanged: (value) {
                            numberValue = value.replaceAll("-", "");
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 250,
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
                      decoration: BoxDecoration(
                        color: Colors.brown.shade200.withOpacity(0.4),
                        borderRadius:
                            BorderRadius.circular(20), // Yuvarlak köşeler için
                      ),
                      child: OutlinedButton(
                        onPressed: () async {
                          getNumberValue = [];
                          var response = await http.get(
                            getBakcell(
                              numberValue,
                              selectedOperator.selectedCategory.toLowerCase(),
                              0,
                              selectedOperator.selectedPrefix
                                  .replaceAll("0", ""),
                              false,
                            ),
                            headers: await getHeaders(0),
                          );
                          if (response.statusCode == 200) {
                            final List<dynamic> jsonData =
                                json.decode(response.body);
                            for (var item in jsonData)
                              // ignore: curly_braces_in_flow_control_structures
                              for (var numbList in item['freeMsisdnList']) {
                                getNumberValue.add(numbList['msisdn']);
                                print(numbList['msisdn']);
                                setState(() {
                                  numberLength = getNumberValue.length;
                                });
                              }
                          } else if (response.statusCode == 500) {
                            print("Key xetasi");
                          } else {
                            print(response.statusCode);
                          }
                          // ignore: use_build_context_synchronously
                          showSnackBar(
                            context,
                            "Tapılan nömrə: ${numberLength.toString()}",
                            2,
                          );
                        },
                        child: const Center(
                          child: Text("Axtar"),
                        ),
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
