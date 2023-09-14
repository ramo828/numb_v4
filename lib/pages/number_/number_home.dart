import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _level = 0;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      _userDataSubscription = _firestore
          .collection('users')
          .doc(_user!.uid)
          .snapshots()
          .listen((userSnapshot) {
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          setState(() {
            _level = userData['level'];
            print(_level);
          });
        } else {
          setState(() {
            // _name = 'Kullanıcı bulunamadı';
            _level = 0;
            print(_level);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _userDataSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedOperator = Provider.of<OperatorProvider>(context);
    final loading = Provider.of<LoadingProvider>(context);

    return Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
        return Scaffold(
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
                      height: 300,
                      // width: 100,
                      decoration: BoxDecoration(
                        color: Colors.brown.shade200.withOpacity(0.4),
                        borderRadius:
                            BorderRadius.circular(20), // Yuvarlak köşeler için
                      ),
                      child: WorkElements(
                        level: _level,
                      ),
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
                                Network net = Network(context: context);
                                if (!(_numberInputController.text.length < 7)) {
                                  net.getData(
                                    _numberInputController.text,
                                    selectedOperator.selectedOperator,
                                    selectedOperator.selectedPrefix,
                                    selectedOperator.selectedCategory,
                                    selectedOperator.selectedFileType,
                                    pref,
                                  );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  showSnackBar(context,
                                      "Xanadaki boşluqları X ilə əvəzləyin", 2);
                                }
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
                                        ShareResultStatus.success) {}
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
