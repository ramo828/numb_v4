import 'package:number_seller/pages/login_page.dart';
import 'package:number_seller/pages/work_elements.dart';
import 'package:number_seller/pages/number_/background/work_functions.dart';
import 'package:number_seller/themes/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController bakcellKeyController = TextEditingController();
  final TextEditingController narKeyController = TextEditingController();
  final underlineInputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    // Çizgiyi şeffaf yapar
  );

  @override
  Widget build(BuildContext context) {
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
        body: ListView(children: [
          buildTextField(
            label: 'BakcellKey',
            icon: const Icon(Icons.key),
            controller: bakcellKeyController,
            uib: underlineInputBorder,
          ),
          buildTextField(
            label: 'NarKey',
            icon: const Icon(Icons.key),
            controller: narKeyController,
            uib: underlineInputBorder,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () async {
                await saveStringList(
                  'settings',
                  [
                    bakcellKeyController.text,
                    narKeyController.text,
                  ],
                );
                print("Bitdi");
              },
              child: const Text("Yadda saxla"),
            ),
          )
        ]),
      );
    });
  }
}
