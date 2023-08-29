import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/pages/register_page.dart';
import 'package:e_com/pages/work_home.dart';
import 'package:e_com/themes/model_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

bool showPass = true;
bool darkTheme = false;
String errorMsg = "";
// ignore: non_constant_identifier_names
List color = [
  Colors.blue.shade50,
  Colors.blue.shade100,
  Colors.blue.shade200,
  Colors.blue.shade300,
  Colors.blue.shade400,
  Colors.blue.shade500,
  Colors.blue.shade600,
  Colors.blue.shade700,
  Colors.blue.shade800,
  Colors.blue.shade900,
];
int colorIndex = color.length - 1;

class LoginScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signInWithEmailAndPassword() async {
    errorMsg = "";
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        // Giriş başarılıysa istediğiniz sayfaya yönlendirebilirsiniz.
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => home_page(),
          ),
        );
      } else {
        errorMsg = "Login ve ya parol boş ola bilməz!";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMsg = 'İstifadəçi tapılmadı.';
      } else if (e.code == 'wrong-password') {
        errorMsg = 'Xətalı şifrə.';
      } else {
        errorMsg = 'Bir xəta baş verdi: ${e.message}';
      }
    } catch (e) {
      errorMsg = "$e";
    }
    if (errorMsg.isNotEmpty) {
      var alert = alert_me(
        errorMsg,
      );
      showDialog(context: context, builder: ((context) => alert));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
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
        body: input(),
      );
    });
  }

  AlertDialog alert_me(String title) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 20, color: darkTheme ? Colors.white : Colors.black),
      ),
      backgroundColor: darkTheme
          ? Colors.black.withOpacity(0.4)
          : Colors.white.withOpacity(0.4),
      icon: Icon(
        FontAwesomeIcons.triangleExclamation,
        color: Colors.yellow.withOpacity(0.5),
        size: 40,
      ),
    );
  }

  ListView input() {
    const underlineInputBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      // Çizgiyi şeffaf yapar
    );
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 330,
                child: logo().animate().fade(duration: 2000.ms).fadeIn(),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.brown.shade200.withOpacity(0.4),
                    borderRadius:
                        BorderRadius.circular(20), // Yuvarlak köşeler için
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      enabledBorder: underlineInputBorder,
                      focusedBorder: underlineInputBorder,
                      // Çizgiyi şeffaf yapar
                      labelText: 'Elektron poçt',
                      prefixIcon: Icon(
                        Icons.login,
                      ),
                    ),
                  ),
                ),
              ).animate().fade(duration: 2000.ms).slide(),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.brown.shade200.withOpacity(0.4),
                    borderRadius:
                        BorderRadius.circular(20), // Yuvarlak köşeler için
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      enabledBorder: underlineInputBorder,
                      focusedBorder: underlineInputBorder,
                      // Çizgiyi şeffaf yapar
                      labelText: 'Şifrə',
                      prefixIcon: const Icon(
                        Icons.password,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (showPass) {
                              showPass = false;
                            } else {
                              showPass = true;
                            }
                          });
                        },
                        icon: Icon(
                          showPass
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeLowVision,
                        ),
                      ),
                    ),
                    obscureText: showPass,
                  ),
                ),
              ).animate().fade(duration: 2000.ms).slide(),
              Padding(
                padding: const EdgeInsets.only(left: 200, top: 0),
                child: GestureDetector(
                  child: Text("Qeydiyyatdan keç",
                      style: TextStyle(
                        color: color[colorIndex],
                      )),
                  onTap: () {
                    setState(() {
                      print(colorIndex);
                      if (colorIndex == 0)
                        colorIndex = color.length - 1;
                      else {
                        colorIndex--;
                      }
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationForm(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  right: 50,
                  left: 50,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(10, 50), // Genişlik ve yükseklik değerleri
                    ),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                        fontSize: 30,
                      ), // Yazı boyutunu ayarla
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors
                        .brown.shade300
                        .withOpacity(0.4)), // Arka plan rengi
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.black45), // Yazı rengi
                    // Diğer özellikleri de burada özelleştirebilirsiniz
                  ),
                  onPressed: _signInWithEmailAndPassword,
                  child: Text(
                    'Daxil Ol',
                    style: TextStyle(
                      fontFamily: 'Lobster',
                      height: 1,
                      color: darkTheme ? Colors.black87 : Colors.white70,
                    ),
                  ),
                ).animate().fade(duration: 2100.ms).slide(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 55,
                  left: 190,
                ),
                child: Text(
                  "RamoSoft 2023",
                  style: TextStyle(
                    fontSize: 20,
                    color: darkTheme ? Colors.brown.shade400 : Colors.white,
                    fontFamily: 'Handwriting',
                  ),
                ).animate().fade(duration: 2000.ms).slide(),
              )
            ],
          ),
        ),
      ],
    );
  }

  Padding logo() {
    return const Padding(
      padding: EdgeInsets.all(45.0),
      child: CircleAvatar(
        radius: 100,
        backgroundImage: AssetImage('assets/indir.jpeg'),
      ),
    );
  }
}

Padding theme(ModelTheme themeNotifier) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 2, right: 10),
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 0,
        ), // Boyutu ayarla
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10)), // Kenar yuvarlaklığı ayarla
        side: BorderSide(
          color: darkTheme ? Colors.brown : Colors.blueGrey,
        ), // Kenarlık rengi ayarla
      ),
      onPressed: () {
        themeNotifier.isDark
            ? themeNotifier.isDark = false
            : themeNotifier.isDark = true;
        darkTheme = themeNotifier.isDark;
      },
      child: Icon(
        color: themeNotifier.isDark ? Colors.blueGrey : Colors.yellow,
        !themeNotifier.isDark ? Icons.sunny : FontAwesomeIcons.moon,
        size: 35,
      ),
    ),
  );
}
