import 'package:flutter/material.dart';

class indexProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void updateIndex(int newOperator) {
    _index = newOperator;
    notifyListeners(); // Değişiklikleri bildir
  }
}
