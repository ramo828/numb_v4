import "package:flutter/material.dart";
import "package:number_seller/pages/number_/background/network.dart";

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

  while (true) {
    print("Page: $counter");
    List<String> numbList = await net.getOperatorData(
      "xxxx$numberData",
      "Bakcell",
      "055",
      "Hamısı",
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
