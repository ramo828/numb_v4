import "package:flutter/material.dart";
import 'package:number_seller/pages/number_/backend/network.dart';
import "package:number_seller/pages/number_/models/active_model.dart";
import "package:provider/provider.dart";

List<String> splitStringByNewline(String inputString) {
  List<String> result = inputString.split('\n');
  return result;
}

List<String> findMissingItems(List<String> newList, List<String> oldList) {
  List<String> missingItems = [];

  for (var item1 in newList) {
    if (!oldList.contains(item1)) {
      missingItems.add(item1);
    }
  }

  return missingItems;
}

String formatNumber(int value) {
  if (value < 10) {
    return '00$value';
  } else if (value < 100) {
    return '0$value';
  } else {
    return value.toString();
  }
}

int counter = 0;

Future<List<String>> loadNumberData(
    String numberData, BuildContext context) async {
  int counter = 0;
  List<String> found = [];
  Network net = Network(context: context);
  final selectedActive = Provider.of<ActiveProvider>(context, listen: false);

  while (true) {
    print("Page: $counter");
    List<String> numbList = await net.getOperatorData(
      numberData,
      selectedActive.selectedOperator,
      selectedActive.selectedPrefix,
      selectedActive.selectedOperator.contains("Bakcell")
          ? selectedActive.selectedCategory
          : selectedActive.selectedCategory.contains("Hamısı")
              ? ""
              : selectedActive.selectedCategory,
      counter,
    );
    counter++;
    if (numbList.isEmpty) {
      break;
    } else {
      found.addAll(numbList);
    }
  }
  return found;
}
