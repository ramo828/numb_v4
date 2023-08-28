import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class buildTextField extends StatelessWidget {
  final String label;
  final Icon icon;
  final TextEditingController controller;
  final UnderlineInputBorder uib;
  final VoidCallback? onPressed;
  final bool obscureText;
  final IconButton? suffixIcon;
  final String? prefixText;
  final TextInputType? inputType;
  final List<TextInputFormatter>? formatter;

  buildTextField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.uib,
    this.onPressed,
    this.obscureText = false,
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
        return TextEditingValue(text: newText + ' ');
      } else if (newText.length == 8 ||
          newText.length == 11 ||
          newText.length == 14) {
        return TextEditingValue(text: newText + ' ');
      }
    } else if (newText.startsWith('+994 ') && newText.length == 15) {
      return TextEditingValue(text: newText);
    }

    return newValue;
  }
}
