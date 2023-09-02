import 'dart:convert';
import 'package:e_com/pages/number_/background/file_io.dart';
import 'package:e_com/pages/number_/background/functions.dart';
import 'package:http/http.dart' as http;
import 'package:e_com/pages/number_/background/number_constant.dart';
import 'package:e_com/pages/number_/background/work_functions.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Network {
  List<String> numberList = [];
  List<String> vcfType = [];

  final BuildContext context;
  Network({
    required this.context,
  });

  Future<List<String>> getBakcellData(
    String number,
    String operator,
    String prefix,
    String category,
    int page,
  ) async {
    List<String> getNumberValue = [];
    int counter = 0;

    var response = await http.get(
      getBakcell(
        number,
        category.toLowerCase(),
        page,
        prefix.replaceAll("0", ""),
        category.contains("Hamısı") ? true : false,
      ),
      headers: await getHeaders(0),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      for (var item in jsonData) {
        // ignore: curly_braces_in_flow_control_structures
        for (var numbList in item['freeMsisdnList']) {
          number = numbList['msisdn'];
          getNumberValue.add("$number\n");
          counter++;
        }
      }
    } else if (response.statusCode == 500) {
      print("Key xetasi");
      print(response.body);
    } else {
      print(response.statusCode);
    }

    return getNumberValue;
  }

  void getData(
    String number,
    String operator,
    String prefix,
    String category,
    String fileType,
  ) async {
    int counter = 0;
    print(number);
    print(operator);
    print(prefix);
    print(category);
    print(fileType);

    func myFunctions = func();
    while (true) {
      var numbList = await getBakcellData(
        number,
        operator,
        prefix,
        category,
        counter,
      );
      counter++;

      if (numbList.length == 0) {
        break;
      } else {
        numberList.addAll(numbList);
      }
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        "Səhifə sayı: ${counter.toString()}",
        2,
      );
    }
    if (fileType.contains("Text")) {
      await writeData(
          numberList
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", "")
              .replaceAll(",", "")
              .replaceAll(" ", ""),
          "numberList.txt");
      print(numberList.toString());
    } else
      // ignore: curly_braces_in_flow_control_structures
      for (int countNumb = 0; countNumb < numberList.length; countNumb++) {
        for (int prefixCount = 0;
            prefixCount < myFunctions.defaultPrefix.length;
            prefixCount++) {
          vcfType.add(
            myFunctions.vcf(
              "Metros",
              myFunctions.defaultPrefix,
              prefixCount,
              numberList[countNumb],
              countNumb,
            ),
          );
        }
      }
    await writeData(
        vcfType
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "")
            .replaceAll(",", "")
            .replaceAll(" ", ""),
        "contact.vcf");
    // ignore: use_build_context_synchronously
    showSnackBar(
      context,
      "Tapılan nömrə: ${numberList.length.toString()}",
      2,
    );
  }
}
