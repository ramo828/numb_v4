import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/pages/number_/number_home.dart';
import 'package:e_com/pages/work_elements.dart';
import 'package:e_com/pages/work_functions.dart';
import 'package:e_com/themes/model_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_page.dart';

class home_page extends StatefulWidget {
  home_page({
    super.key,
  });

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? _keysSubscription;
  StreamSubscription<DocumentSnapshot>? _notificationSubscription;

  Map<String, dynamic>? _keysData;
  Map<String, dynamic>? _notificationData;
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  User? _user;
  String _name = '';
  String _surname = '';
  String _deviceID = '';
  String _registerDate = '';
  bool _logOut = false;
  bool _notifStatus = false;
  String _message = "";
  bool _updateStatus = false;
  String _updateLink = '';
  String _updateContent = '';
  String _updateTitle = '';

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
            _notifStatus = _notificationData!['status'];
          });
        }
      });

      _notificationSubscription = _firestore
          .collection('settings')
          .doc('update')
          .snapshots()
          .listen((notificationSnapshot) {
        if (notificationSnapshot.exists) {
          setState(() {
            _notificationData =
                notificationSnapshot.data() as Map<String, dynamic>;
            _updateStatus = _notificationData!['status'];
            _updateContent = _notificationData!['content'];
            _updateTitle = _notificationData!['title'];
            _updateLink = _notificationData!['url'];
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

  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.brown.shade400.withOpacity(0.3),
          height: 25,
          destinations: [
            OutlinedButton(
              child: Icon(Icons.home),
              onPressed: () {},
            ),
            OutlinedButton(
              child: Icon(Icons.list),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => number_home(),
                  ),
                );
              },
            ),
            OutlinedButton(
              child: Icon(Icons.settings),
              onPressed: () {},
            ),
            OutlinedButton(
              child: Icon(Icons.exit_to_app),
              onPressed: () {
                saveBoolValue('logIn', false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          toolbarHeight: 65,
          centerTitle: true,
          actions: [
            theme(themeNotifier),
          ],
          title: Padding(
            padding: EdgeInsets.all(8.0),
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
        body: Column(
          children: [
            FutureBuilder<bool>(
              future: equalDeviceID(_deviceID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Yükleniyor göstergesi
                } else if (snapshot.hasError) {
                  return Text("Hata: ${snapshot.error}");
                } else {
                  bool isEqual = snapshot.data ?? false;
                  if (isEqual) {
                    return work_info(
                        name: _name,
                        surname: _surname,
                        registerDate: _registerDate,
                        notifStatus: _notifStatus,
                        notifMessage: _message,
                        updateStatus: _updateStatus,
                        updateTitle: _updateTitle,
                        updateContent: _updateContent,
                        updateUrl: _updateLink);
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
          ],
        ),
      );
    });
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
  my_container({
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
