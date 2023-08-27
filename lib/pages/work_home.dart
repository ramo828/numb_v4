import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/themes/model_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

class home_page extends StatefulWidget {
  home_page({
    super.key,
  });

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  User? _user;
  String _name = '';
  String _age = '';

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
            _age = userData['age'];
          });
        } else {
          setState(() {
            _name = 'Kullanıcı bulunamadı';
            _age = '';
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
        body: Text("$_name $_age"),
      );
    });
  }
}
