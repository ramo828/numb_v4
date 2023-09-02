import 'package:flutter/material.dart';

class OperatorProvider extends ChangeNotifier {
  String _selectedOperator = 'Bakcell';
  String _selectedPrefix = '055';
  String _selectedCategory = 'Hamısı';
  String _selectedFileType = 'Text';

  String get selectedOperator => _selectedOperator;
  String get selectedPrefix => _selectedPrefix;
  String get selectedCategory => _selectedCategory;
  String get selectedFileType => _selectedFileType;

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

  void updateSelectedFileType(String newOperator) {
    _selectedFileType = newOperator;
    notifyListeners(); // Değişiklikleri bildir
  }
}
