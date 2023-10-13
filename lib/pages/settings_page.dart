import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:number_seller/pages/login_page.dart';
import 'package:number_seller/pages/work_elements.dart';
import 'package:number_seller/pages/number_/background/work_functions.dart';
import 'package:number_seller/pages/number_/models/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String cName = "";
String bakcellKey = "";
String narKey = "";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController bakcellKeyController =
      TextEditingController(text: bakcellKey);
  final TextEditingController narKeyController =
      TextEditingController(text: narKey);
  final TextEditingController contactNameController =
      TextEditingController(text: cName);

  final underlineInputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    // Çizgiyi şeffaf yapar
  );

  void getContactData() async {
    var temp = await getStringList("contactName");
    var tempKey = await getStringList("keys");
    bakcellKey = tempKey[0];
    narKey = tempKey[1];
    print("nar: $narKey");
    if (temp[0].isEmpty) {
      cName = "Metros";
    } else {
      cName = temp[0];
    }
  }

  @override
  void initState() {
    getContactData();
    // TODO: implement initState
    super.initState();
  }

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
          buildTextField(
            label: 'Kontaktların adı',
            icon: const Icon(FontAwesomeIcons.addressBook),
            controller: contactNameController,
            uib: underlineInputBorder,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () async {
                FirebaseFunctions ff = FirebaseFunctions();
                if (bakcellKeyController.text.isNotEmpty) {
                  await ff.updateField(
                      "settings", "keys", "bakcell", bakcellKeyController.text);
                }
                if (narKeyController.text.isNotEmpty) {
                  await ff.updateField(
                      "settings", "keys", "nar", narKeyController.text);
                }
                await saveStringList(
                  'contactName',
                  [
                    contactNameController.text,
                  ],
                );
                showSnackBar(context, "Ayarlar qeyd edildi", 2);
                setState(() {
                  getContactData();
                });
              },
              child: const Text("Yadda saxla"),
            ),
          )
        ]),
      );
    });
  }
}
