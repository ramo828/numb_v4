// ignore_for_file: unused_element

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:number_seller/pages/active_/active_page.dart';
import 'package:number_seller/pages/notification_page.dart';
import 'package:number_seller/pages/number_/background/number_constant.dart';
import 'package:number_seller/pages/number_/models/index_models.dart';
import 'package:number_seller/pages/number_/models/status_models.dart';
import 'package:number_seller/pages/number_/number_home.dart';
import 'package:number_seller/pages/settings_page.dart';
import 'package:number_seller/pages/work_elements.dart';
import 'package:number_seller/pages/number_/background/work_functions.dart';
import 'package:number_seller/pages/number_/models/model_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

int _currentIndex = 0;
final PageController _pageController = PageController();
AutoKey autoKey = AutoKey("824-0038", "samir9995099");
String _deviceID = '';
bool _updateStatus = false;
String _updateLink = '';
String _updateContent = '';
String _updateTitle = '';
String real_version = "4.1.9b";
bool _isAdmin = false;
String _name = '';
String _surname = '';
String _registerDate = '';
String _email = '';
int _level = 0;
bool _logOut = false;
bool _notifStatus = false;
String _message = "";

bool _isActive = false;
String _bakcellKey = "";
String _narKey = "";
String _version = "";
String _title = "";
StreamSubscription<DocumentSnapshot>? _notificationSubscription;
StreamSubscription<DocumentSnapshot>? _keySubscription;
StreamSubscription<DocumentSnapshot>? _updateSubscription;

class home_page extends StatefulWidget {
  const home_page({
    super.key,
  });

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _keysData;
  Map<String, dynamic>? _notificationData;
  Map<String, dynamic>? _updateData;

  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
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
            _name = userData['name'];
            _surname = userData['surname'];
            _deviceID = userData['deviceID'];
            _logOut = userData['logOut'];
            _registerDate = userData['registerDate'];
            _email = userData['email'];
            _isActive = userData['isActive'];
            _isAdmin = userData['isAdmin'];
            _level = userData['level'];
          });
        } else {
          setState(() {
            _name = 'Kullanıcı bulunamadı';
          });
        }
      });

      _notificationSubscription = _firestore
          .collection('settings')
          .doc('notification')
          .snapshots()
          .listen((notificationSnapshot) {
        if (notificationSnapshot.exists) {
          setState(() {
            _notificationData =
                notificationSnapshot.data() as Map<String, dynamic>;
            _message = _notificationData!['message'];
            _title = _notificationData!['title'];
            _notifStatus = _notificationData!['status'];
          });
        }
      });
      _keySubscription = _firestore
          .collection('settings')
          .doc('keys')
          .snapshots()
          .listen((notificationSnapshot) {
        if (notificationSnapshot.exists) {
          setState(() {
            _keysData = notificationSnapshot.data() as Map<String, dynamic>;
            _bakcellKey = _keysData!['bakcell'];
            _narKey = _keysData!['nar'];
          });
        }
      });

      _updateSubscription = _firestore
          .collection('settings')
          .doc('update')
          .snapshots()
          .listen((notificationSnapshot) {
        if (notificationSnapshot.exists) {
          setState(() {
            _updateData = notificationSnapshot.data() as Map<String, dynamic>;
            _updateStatus = _updateData!['status'];
            _updateContent = _updateData!['content'];
            _updateTitle = _updateData!['title'];
            _updateLink = _updateData!['url'];
            _version = _updateData!['version'];
          });
        }
      });
    }
    // requestPermissions();
  }

  @override
  void dispose() {
    _userDataSubscription?.cancel();
    _notificationSubscription?.cancel();
    _userDataSubscription?.cancel();
    _keySubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusProv = Provider.of<statusProvider>(context, listen: false);
    if (_logOut) {
      saveBoolValue("logIn", false);
      exit(1);
    } else {}
    saveStringList("keys", [_bakcellKey, _narKey]);
    //Bakcell ve nar keyleri burdan yuklenecek
    Future.delayed(Duration.zero, () {
      statusProv.updateStatus(_isActive);
    });
    // hesab aktivlik bilgisi burdan diger widgete oturulur
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      final indexProv = Provider.of<indexProvider>(context, listen: true);

      return Scaffold(
          drawer: Drawer(
            backgroundColor: Colors.brown.shade100.withOpacity(0.8),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  otherAccountsPicturesSize: const Size.square(63),
                  otherAccountsPictures: [
                    Padding(
                        padding: const EdgeInsets.only(right: 1),
                        child: theme(
                          themeNotifier,
                        )),
                  ],
                  currentAccountPictureSize: const Size(60, 60),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade300
                        .withOpacity(0.8), // Arka plan rengi
                  ),
                  accountName: Text(
                    "$_name $_surname",
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontFamily: 'Handwriting',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  accountEmail: Text(
                    _email,
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontFamily: 'Handwriting',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  currentAccountPicture: const CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/indir.jpeg'),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Ana Səhifə'),
                  onTap: () {
                    // Ana sayfaya gitmek için yapılacak işlemler burada
                    Navigator.pop(context); // Drawer'ı kapat
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Ayarlar'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(FontAwesomeIcons.universalAccess),
                  title: const Text('İcazələri yoxla'),
                  onTap: () async {
                    await requestPermissions();
                  },
                ),

                const Divider(), // Ayırıcı çizgi ekleyebilirsiniz
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Çıxış'),
                  onTap: () {
                    saveBoolValue("logIn", false);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.brown.shade400.withOpacity(0.3),
            currentIndex: indexProv.index,
            onTap: (int index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 50),
                curve: Curves.ease,
              );
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Ana səhifə',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Siyahı hazırla',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                label: 'Yeni nömrələr',
              ),
            ],
          ),
          appBar: AppBar(
            // automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            toolbarHeight: 65,
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Badge(
                  isLabelVisible: _notifStatus,
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => notification(
                                message: _message,
                                notifStatus: true,
                                title: _title),
                          ),
                        );
                      },
                      icon: const Icon(
                        FontAwesomeIcons.bell,
                      )),
                ),
              )
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
          body: const work_body());
    });
  }
}

class work_body extends StatefulWidget {
  const work_body({super.key});

  @override
  State<work_body> createState() => _work_bodyState();
}

class _work_bodyState extends State<work_body> {
  @override
  Widget build(BuildContext context) {
    final indexProv = Provider.of<indexProvider>(context, listen: false);
    final isStatus = Provider.of<statusProvider>(context, listen: true);
    return PageView(
      controller: _pageController,
      children: [
        Column(children: [
          FutureBuilder(
            future: Future.wait([autoKey.getKey(), equalDeviceID(_deviceID)]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: LinearProgressIndicator(),
                ); // Yükleniyor göstergesi
              } else if (snapshot.hasError) {
                return Text("Hata: ${snapshot.error}");
              } else {
                Object isEqual = snapshot.data![1];
                dataUpdate(
                    "settings", 'keys', {'nar': 'Bearer ${snapshot.data?[0]}'});
                //Nar keyi burdan gelir
                if (isEqual as bool) {
                  return work_info(
                    name: _name,
                    surname: _surname,
                    registerDate: _registerDate,
                    updateStatus: _updateStatus,
                    updateTitle: _updateTitle,
                    updateContent: _updateContent,
                    updateUrl: _updateLink,
                    isActive: _isActive,
                    updateVersion: [_version, real_version],
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: my_container(
                        color: Colors.brown.shade500.withOpacity(0.5),
                        child: const Text(
                          "Siz bu hesabı işlədə bilməzsiniz. Bu hesab başqa cihaza aitdir",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Lobster",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ]),
        isStatus.status == true && _level != 2
            ? const number_home()
            : const Center(
                child: Text("Sizin hesab aktiv degil"),
              ),
        isStatus.status == true && _level >= 2
            ? active_page(
                level: _level,
              )
            : const Center(
                child: Text("Sizin hesab aktiv degil"),
              ),
      ],
      onPageChanged: (int index) {
        indexProv.updateIndex(index);
      },
    );
  }
}

class double_string extends StatelessWidget {
  final String text1;
  final String text2;
  final String fontName1;
  final String fontName2;
  final Color color1;
  final Color color2;

  const double_string({
    super.key,
    required this.text1,
    required this.text2,
    this.color1 = Colors.black,
    this.color2 = Colors.red,
    required this.fontName1,
    required this.fontName2,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text1,
            style: TextStyle(
              fontFamily: fontName1, // İlk fontun adı
              fontSize: 20,
              color: color1,
            ),
          ),
          TextSpan(
            text: text2,
            style: TextStyle(
                fontFamily: fontName2, // İkinci fontun adı
                fontSize: 24,
                color: color2,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class my_container extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final Color color;
  const my_container({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.color = Colors.brown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20), // Yuvarlak köşeler için
      ),
      child: child,
    );
  }
}
