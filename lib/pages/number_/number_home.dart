import 'package:e_com/pages/login_page.dart';
import 'package:e_com/pages/number_/background/file_io.dart';
import 'package:e_com/pages/number_/background/network.dart';
import 'package:e_com/pages/number_/models/number_models.dart';
import 'package:e_com/pages/number_/number_widgets.dart';
import 'package:e_com/themes/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 85,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.brown.shade200.withOpacity(0.4),
                        borderRadius:
                            BorderRadius.circular(20), // Yuvarlak köşeler için
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9xX]')),
                          ],
                          maxLength: 7,
                          decoration: const InputDecoration(
                            enabledBorder: underlineInputBorder,
                            focusedBorder: underlineInputBorder,
                            // Çizgiyi şeffaf yapar
                            hintText: 'XXX-XX-XX',
                          ),
                          initialValue: "",
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
                          Network net = Network(context: context);
                          // net.getData(
                          //   numberValue,
                          //   selectedOperator.selectedOperator,
                          //   selectedOperator.selectedPrefix,
                          //   selectedOperator.selectedCategory,
                          // );
                          net.getData(
                            '65xxxxx',
                            'Bakcell',
                            '099',
                            'Bürünc',
                          );
                          // print(data);
                        },
                        child: const Center(
                          child: Text("Axtar"),
                        ),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      var data = await readData();
                      print(data);
                    },
                    child: Icon(Icons.read_more),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
