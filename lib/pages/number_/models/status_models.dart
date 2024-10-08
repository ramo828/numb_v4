import 'package:flutter/material.dart';

class statusProvider extends ChangeNotifier {
  bool _status = false;

  bool get status => _status;

  void updateStatus(bool newOperator) {
    _status = newOperator;
    notifyListeners(); // Değişiklikleri bildir
  }
}
