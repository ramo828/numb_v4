import "package:flutter/material.dart";
import "package:number_seller/pages/number_/background/network.dart";
import "package:number_seller/pages/number_/models/active_model.dart";
import "package:number_seller/pages/number_/models/number_models.dart";
import "package:provider/provider.dart";

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
      "xxxx$numberData",
      selectedActive.selectedOperator,
      selectedActive.selectedPrefix,
      selectedActive.selectedOperator.contains("Bakcell") ? "Hamısı" : "7077",
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
