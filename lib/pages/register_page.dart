import 'package:e_com/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:e_com/themes/model_theme.dart';

bool showPass = false;
bool passCheck = true;

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();

  Future<void> _register() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Kullanıcı başarıyla kaydedildi, burada istediğiniz işlemleri yapabilirsiniz
      } catch (e) {
        // Kayıt sırasında bir hata oluştu, burada hata mesajını görüntüleyebilirsiniz
        print("Hata: $e");
      }
    } else {
      print("Email ve sifre bos ola bilmez");
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
                height: 250,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'E-posta boş bırakılamaz';
                      }
                      return null;
                    },
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
                  )).animate().fade(duration: 2000.ms).slide(),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.brown.shade200.withOpacity(0.4),
                    borderRadius:
                        BorderRadius.circular(20), // Yuvarlak köşeler için
                  ),
                  child: TextFormField(
                    controller: _passwordController1,
                    decoration: InputDecoration(
                      enabledBorder: underlineInputBorder,
                      focusedBorder: underlineInputBorder,
                      prefixIconColor: passCheck ? Colors.black : Colors.red,
                      // Çizgiyi şeffaf yapar
                      labelText: 'Təkrar şifrə',
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
                    onChanged: (pass) {
                      if (_passwordController.text != pass) {
                        setState(() {
                          passCheck = false;
                        });
                      } else {
                        setState(() {
                          passCheck = true;
                        });
                      }
                    },
                  ),
                ),
              ).animate().fade(duration: 2000.ms).slide(),
              SizedBox(height: 16),
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
}
