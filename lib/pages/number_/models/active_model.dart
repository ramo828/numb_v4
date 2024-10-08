import 'package:flutter/material.dart';

class ActiveProvider extends ChangeNotifier {
  String _selectedOperator = 'Nar';
  String _selectedPrefix = '070';
  String _selectedOperation = "Köhnə baza";
  String _selectedCategory = 'Hamısı';
  List<bool> _newNumberCheckStatus = List.generate(10000000, (index) => false);
  final List<String> _newNumberList = [];

  String get selectedOperator => _selectedOperator;
  String get selectedPrefix => _selectedPrefix;
  String get selectedOperaton => _selectedOperation;
  String get selectedCategory => _selectedCategory;
  List<bool> get newNumberCheckStatus => _newNumberCheckStatus;
  List<String> get newNumberList => _newNumberList;

  void updateNewNumberList(String newOperator) {
    _newNumberList.add(newOperator);
    notifyListeners(); // Değişiklikleri bildir
  }

  void clearNewNumberList() {
    _newNumberList.clear();
    notifyListeners(); // Değişiklikleri bildir
  }

  void removeNewNumberList(String newOperator) {
    _newNumberList.remove(newOperator);
    notifyListeners(); // Değişiklikleri bildir
  }

  void updateNewNumberCheckStatus(bool newOperator, int index) {
    _newNumberCheckStatus[index] = newOperator;
    notifyListeners(); // Değişiklikleri bildir
  }

  void clearNewNumberCheckStatus() {
    _newNumberCheckStatus = List.generate(10000000, (index) => false);
    notifyListeners(); // Değişiklikleri bildir
  }

  bool getNewNumberCheckStatusAtIndex(int index) {
    if (index >= 0 && index < _newNumberCheckStatus.length) {
      return _newNumberCheckStatus[index];
    }
    // Geçersiz endeks durumunda ne yapılacağını belirleyin (örneğin false döndürün veya hata işleyin).
    return false;
  }

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
