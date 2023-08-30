import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/pages/login_page.dart';
import 'package:e_com/pages/work_elements.dart';
import 'package:e_com/pages/work_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:e_com/themes/model_theme.dart';

bool showPass = false;
bool passCheck = true;
bool access = false;
String errorMsg = "";

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _suname = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _register() async {
    errorMsg = "";
    String name = _name.text;
    String surname = _suname.text;
    String phoneNumber = _phone.text;
    String email = _emailController.text;
    String deviceID = await getDeviceID();

    if (_emailController.text.length > 5 &&
        _passwordController.text.length > 5) {
      if (access) {
        if (_emailController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty) {
          try {
            UserCredential userCredential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );
            User? user =
                auth.currentUser; // Kaydedilen kullanıcının bilgilerini al
            if (user != null) {
              await saveUserData(
                user.uid,
                name,
                surname,
                phoneNumber,
                email,
                calculateMD5(deviceID),
              ); // Kullanıcıya özel verileri kaydet
            }
            // Kullanıcı başarıyla kaydedildi, burada istediğiniz işlemleri yapabilirsiniz
            // ignore: use_build_context_synchronously
            Navigator.pop(
                context); // Başarılı kayıt durumunda önceki sayfaya geri dön
          } catch (e) {
            // Kayıt sırasında bir hata oluştu, burada hata mesajını görüntüleyebilirsiniz
            if (e is FirebaseAuthException) {
              if (e.code == 'weak-password') {
                errorMsg = "Güclü şifrədəm istifadə edin!";
              } else if (e.code == 'email-already-in-use') {
                errorMsg = "Email adresi artıq istifadə edilir!";
              } else {
                errorMsg = 'Bilinmətən bir xəta: ${e.message}';
              }
            } else {
              errorMsg = 'Bilinmətən bir xəta: ${e}';
            }
            var alert = alert_me(errorMsg);
            showDialog(context: context, builder: ((context) => alert));
          }
        } else {
          var alert = alert_me("Email ve sifre bos ola bilmez");
          showDialog(context: context, builder: ((context) => alert));
        }
      } else {
        var alert = alert_me("Şifrələr uyğun deyil!");
        showDialog(context: context, builder: ((context) => alert));
      }
    } else {
      var alert = alert_me("Şifrə ən az 6 simvoldan ibarət ola bilər!");
      showDialog(context: context, builder: ((context) => alert));
    }
  }

  @override
  Widget build(BuildContext context) {
    const underlineInputBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      // Çizgiyi şeffaf yapar
    );
    return Consumer(builder: (context, ModelTheme themeNotifier, child) {
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
        body: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 25,
              ),
              buildTextField(
                label: 'Ad',
                icon: const Icon(
                  Icons.person,
                ),
                controller: _name,
                uib: underlineInputBorder,
              ),
              buildTextField(
                label: 'Soyad',
                icon: const Icon(
                  Icons.person,
                ),
                controller: _suname,
                uib: underlineInputBorder,
              ),
              buildTextField(
                label: 'Mobil nömrə',
                icon: const Icon(
                  Icons.phone_in_talk,
                ),
                controller: _phone,
                uib: underlineInputBorder,
                inputType: TextInputType.phone,
                prefixText: "+994",
                formatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9+]*$')),
                  PhoneNumberFormatter(),
                ],
              ),
              buildTextField(
                label: 'Elektron poçt',
                icon: const Icon(
                  Icons.login,
                ),
                controller: _emailController,
                uib: underlineInputBorder,
              ),
              buildTextField(
                label: 'Şifrə',
                icon: const Icon(
                  Icons.password,
                ),
                controller: _passwordController,
                uib: underlineInputBorder,
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
                obscureText: showPass,
              ),
              buildTextField(
                label: 'Təkrar Şifrə',
                icon: Icon(
                  Icons.password,
                  color: passCheck ? Colors.black : Colors.red,
                ),
                controller: _passwordController1,
                uib: underlineInputBorder,
                onChanged: (value) {
                  setState(() {
                    if (_passwordController.text != value) {
                      passCheck = false;
                      access = false;
                    } else {
                      passCheck = true;
                      access = true;
                    }
                  });
                },
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
                obscureText: showPass,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  right: 50,
                  left: 50,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(55, 30), // Genişlik ve yükseklik değerleri
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
                  onPressed: _register,
                  child: Text(
                    'Qeydiyyat',
                    style: TextStyle(
                      fontFamily: 'Lobster',
                      height: 1,
                      color: darkTheme ? Colors.black87 : Colors.white70,
                    ),
                  ),
                ).animate().fade(duration: 2100.ms).slide(),
              ),
            ],
          ),
        ]),
      );
    });
  }

  Future<void> saveUserData(
    String userId,
    String name,
    String surname,
    String phone_number,
    String email,
    String deviceID,
  ) async {
    try {
      await firestore.collection('users').doc(userId).set({
        'name': name,
        'surname': surname,
        'phone_number': phone_number,
        'email': email,
        'deviceID': deviceID,
        'isAdmin': false,
      });
    } catch (e) {
      print("Hata: $e");
    }
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
}
