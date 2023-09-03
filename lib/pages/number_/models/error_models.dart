import 'package:flutter/material.dart';

class ErrorProvider extends ChangeNotifier {
  String _error = "";

  String get error => _error;

  void updateError(String newOperator) {
    _error = newOperator;
    notifyListeners(); // Değişiklikleri bildir
  }
}
