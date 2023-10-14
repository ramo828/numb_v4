import 'package:number_seller/pages/number_/background/work_functions.dart';
import 'package:number_seller/pages/work_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class buildTextField extends StatelessWidget {
  final String label;
  final Icon icon;
  final TextEditingController controller;
  final UnderlineInputBorder uib;
  final VoidCallback? onPressed;
  final ValueSetter<String>? onChanged;
  final bool obscureText;
  final IconButton? suffixIcon;
  final String? prefixText;
  final TextInputType? inputType;
  final List<TextInputFormatter>? formatter;
  final bool enabled;

  const buildTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.uib,
    this.onPressed,
    this.onChanged,
    this.obscureText = false,
    this.enabled = true,
    this.suffixIcon,
    this.prefixText,
    this.inputType,
    this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.brown.shade200.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFormField(
            enabled: enabled,
            onChanged: onChanged,
            inputFormatters: formatter,
            keyboardType: inputType,
            obscureText: obscureText,
            controller: controller,
            decoration: InputDecoration(
              prefixText: prefixText,
              suffixIcon: suffixIcon,
              enabledBorder: uib,
              focusedBorder: uib,
              labelText: label,
              prefixIcon: icon,
            ),
          ),
        ),
      ),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Doğru format: +994 XX XXX XX XX
    final newText = newValue.text;

    if (newText.startsWith('+994')) {
      if (newText.length == 5) {
        return TextEditingValue(text: '$newText ');
      } else if (newText.length == 8 ||
          newText.length == 11 ||
          newText.length == 14) {
        return TextEditingValue(text: '$newText ');
      }
    } else if (newText.startsWith('+994 ') && newText.length == 15) {
      return TextEditingValue(text: newText);
    }

    return newValue;
  }
}

class work_info extends StatefulWidget {
  final String name;
  final String surname;
  final String registerDate;
  final bool updateStatus;
  final List<String> updateVersion;
  final String updateTitle;
  final String updateContent;
  // final String updateUrl;
  final bool isActive;

  const work_info({
    super.key,
    required this.name,
    required this.surname,
    required this.registerDate,
    required this.updateStatus,
    required this.updateTitle,
    required this.updateContent,
    // required this.updateUrl,
    required this.isActive,
    required this.updateVersion,
  });

  @override
  State<work_info> createState() => _work_infoState();
}

class _work_infoState extends State<work_info> {
  bool update = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          my_container(
            color: Colors.brown.shade300,
            height: 300,
            width: 350,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: my_container(
                    height: 35,
                    color: const Color.fromARGB(255, 112, 104, 103)
                        .withOpacity(0.4),
                    width: 325,
                    child: const Center(
                      child: Text(
                        "Istifadəçi bilgiləri",
                        style: TextStyle(
                          fontFamily: 'Handwriting',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                my_container(
                  height: 30,
                  width: 280,
                  color: Colors.brown.shade500.withOpacity(0.5),
                  child: Center(
                    child: double_string(
                      text1: "Ad: ",
                      text2: widget.name,
                      fontName1: "Lobster",
                      fontName2: "Handwriting",
                      color2: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                my_container(
                  height: 30,
                  width: 280,
                  color: Colors.brown.shade500.withOpacity(0.5),
                  child: Center(
                    child: double_string(
                      text1: "Soyad: ",
                      text2: widget.surname,
                      fontName1: "Lobster",
                      fontName2: "Handwriting",
                      color2: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                my_container(
                  height: 30,
                  width: 280,
                  color: Colors.brown.shade500.withOpacity(0.5),
                  child: Center(
                    child: double_string(
                      text1: "Qeyd. Tarix: ",
                      text2: widget.registerDate,
                      fontName1: "Lobster",
                      fontName2: "Handwriting",
                      color2: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                my_container(
                  height: 30,
                  width: 280,
                  color: Colors.brown.shade500.withOpacity(0.5),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: double_string(
                        text1: "Status: ",
                        text2: widget.isActive ? "Aktiv" : "Passiv",
                        fontName1: "Lobster",
                        fontName2: "Handwriting",
                        color2: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                my_container(
                  height: 30,
                  width: 280,
                  color: Colors.brown.shade500.withOpacity(0.5),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: double_string(
                        text1: "Versiya: ",
                        text2: widget.updateVersion[1],
                        fontName1: "Lobster",
                        fontName2: "Handwriting",
                        color2: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          widget.updateStatus &&
                  widget.updateVersion[0] != widget.updateVersion[1]
              ? my_container(
                  height: 145,
                  width: 350,
                  color: Colors.brown.shade600.withOpacity(0.4),
                  child: Column(
                    children: [
                      Text(
                        widget.updateTitle,
                        style: const TextStyle(
                          fontFamily: 'Handwriting',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        widget.updateContent,
                        style: const TextStyle(
                          fontFamily: 'Handwriting',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      update
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const Center(),
                      OutlinedButton(
                        child: const Text(
                          "Yenilə",
                          style: TextStyle(
                            fontFamily: 'Handwriting',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            update = true;
                          });
                          FirebaseFunctions ff = FirebaseFunctions();
                          var url = await ff.downloadFile1(
                              "gs://mekan-4c393.appspot.com/app-release.apk");
                          launchURLupdate(url);
                          setState(() {
                            update = false;
                          });
                        },
                      ),
                    ],
                  ),
                )
              : const Text('')
        ],
      ),
    );
  }
}
