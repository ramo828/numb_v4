import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  bool _load = false;
  bool _okay = false;

  bool get load => _load;
  bool get okay => _okay;

  void updateLoad(bool newOperator) {
    _load = newOperator;
    notifyListeners(); // Değişiklikleri bildir
  }

  void updateOkay(bool newOperator) {
    _okay = newOperator;
    notifyListeners(); // Değişiklikleri bildir
  }
}
