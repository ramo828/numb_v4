import 'package:flutter/material.dart';

class OperatorProvider extends ChangeNotifier {
  String _selectedOperator = 'Azercell';
  String _selectedPrefix = '050';
  String _selectedCategory = 'Hamısı';

  String get selectedOperator => _selectedOperator;
  String get selectedPrefix => _selectedPrefix;
  String get selectedCategory => _selectedCategory;

  void updateSelectedOperator(String newOperator) {
    _selectedOperator = newOperator;
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
