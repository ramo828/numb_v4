import 'dart:convert';
import 'package:number_seller/pages/number_/background/file_io.dart';
import 'package:number_seller/pages/number_/models/loading_models.dart';
import 'package:http/http.dart' as http;
import 'package:number_seller/pages/number_/background/number_constant.dart';
import 'package:number_seller/pages/number_/background/work_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Network {
  List<String> numberList = [];
  List<String> vcfType = [];

  final BuildContext context;
  Network({
    required this.context,
  });

  Future<List<String>> getOperatorData(
    String number,
    String operator,
    String prefix,
    String category,
    int page,
  ) async {
    List<String> getNumberValue = [];
    int counter = 0;

    var response = await http.get(
      operator.contains("Bakcell")
          ? getBakcell(
              number,
              category.toLowerCase(),
              page,
              prefix.replaceAll("0", ""),
              category.contains("Hamısı") ? true : false,
            )
          : getNar(
              number,
              category,
              prefix.contains("070")
                  ? prefix.replaceAll("070", "70")
                  : prefix.contains("077")
                      ? prefix.replaceAll("0", "")
                      : prefix,
              page,
              category.contains("Hamısı") ? true : false,
            ),
      headers: await getHeaders(operator.contains("Bakcell") ? 0 : 1),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      for (var item in jsonData) {
        if (operator.contains("Bakcell")) {
          for (var numbList in item['freeMsisdnList']) {
            // for (var numbList in item) {
            number = numbList['msisdn'];
            getNumberValue.add("$number\n");
            counter++;
          }
        } else {
          number = item['msisdn'];
          getNumberValue.add("$number\n");
          counter++;
        }
      }
    } else if (response.statusCode == 500) {
      showSnackBar(context, "Key xətası: ${response.body}", 2);
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
    List<String> prefixList,
  ) async {
    int counter = 0;
    int countNumb = 0;
    int prefixCounter = 0;
    final loading = Provider.of<LoadingProvider>(context, listen: false);
    loading.updateOkay(false);
    loading.updateLoad(true);
    func myFunctions = func();

    while (true) {
      var numbList = await getOperatorData(
        number,
        operator,
        prefix,
        category,
        counter,
      );

      counter++;

      if (numbList.isEmpty) {
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
      try {
        await writeData(
            numberList
                .toString()
                .replaceAll("[", "")
                .replaceAll("]", "")
                .replaceAll(",", "")
                .replaceAll(" ", ""),
            "numberList.txt");
      } catch (e) {
        showSnackBar(context, "Xəta: $e", 2);
      }
    } else if (fileType.contains("VCF") || fileType.contains("VCF(Zip)")) {
      while (countNumb <= numberList.length - 1) {
        for (int prefixCount = 0;
            prefixCount < prefixList.length;
            prefixCount++) {
          vcfType.add(
            myFunctions.vcf(
              "Metros",
              prefixList,
              prefixCount,
              numberList[countNumb],
              prefixCounter,
            ),
          );
          prefixCounter++;
        }
        countNumb++;
      }
    }
    try {
      await writeData(
          vcfType
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", "")
              .replaceAll(",", "")
              .replaceAll(" ", ""),
          "contact.vcf");
    } catch (e) {
      showSnackBar(context, "Xəta: $e", 2);
    }
    // ignore: use_build_context_synchronously
    showSnackBar(
      context,
      "Tapılan nömrə: ${numberList.length.toString()}",
      2,
    );
    if (fileType.contains("VCF(Zip)")) {
      zipFile('/sdcard/work/contact.vcf', '/sdcard/work/contact.vcf.zip');
    }
    loading.updateOkay(true);
    loading.updateLoad(false);
  }
}
