import 'package:flutter/material.dart';

class ActiveProvider extends ChangeNotifier {
  String _selectedOperator = 'Nar';
  String _selectedPrefix = '070';
  String _selectedOperation = "Köhnə baza";
  String _selectedCategory = 'Hamısı';

  String get selectedOperator => _selectedOperator;
  String get selectedPrefix => _selectedPrefix;
  String get selectedOperaton => _selectedOperation;
  String get selectedCategory => _selectedCategory;

  void updateSelectedOperator(String newOperator) {
    _selectedOperator = newOperator;
    notifyListeners(); // Değişiklikleri bildir
  }

  void updateSelectedOperation(String newOperator) {
    _selectedOperation = newOperator;
    notifyListeners(); // Değişiklikleri bildir
  }

  void updateSelectedPrefix(String newOperator) {
    _selectedPrefix = newOperator;
    notifyListeners(); // Değişiklikleri bildir
  }

  void updateSelectedCategory(String newOperator) {
    _selectedCategory = newOperator;
    notifyListeners(); // Değişiklikleri bildir
  }
}
