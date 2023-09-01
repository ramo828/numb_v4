// ignore: camel_case_types
class func {
  List<String> dataVcard = [
    "BEGIN:VCARD\n",
    "N:",
    "FN:",
    "TEL;TYPE=WORK,MSG:",
    "EMAIL;TYPE=INTERNET:\n",
    "END:VCARD\n"
  ];

  List<String> defaultPrefix = [
    "+99450",
    "+99451",
    "+99410",
    "+99455",
    "+99499",
    "+99470",
    "+99477",
    "+99460"
  ];

  String splitNumberData(String data) {
    // ignore: unnecessary_null_comparison
    if (data.isNotEmpty || data != null) {
      String pref = data.substring(0, 2);
      String a1 = data.substring(2, 5);
      String a2 = data.substring(5, 7);
      String a3 = data.substring(7, 9);

      return "0$pref-$a1-$a2-$a3";
    } else {
      throw ("Boş və ya null data göndərilə bilməz!");
    }
  }

  String vcf(String contactName, List<String> prefix, int prefixIndex,
      String number, int counter) {
    try {
      return "${dataVcard[0]}${dataVcard[1]}$contactName$counter\n${dataVcard[2]}$contactName$counter\n${dataVcard[3]}${prefix[prefixIndex]}${number.substring(2, 9)}\n${dataVcard[4]}${dataVcard[5]}";
    } catch (e, s) {
      print(e);
      print(s);
      return "";
    }
  }

  String vcfRaw(String contactName, String number, int counter) {
    try {
      return "${dataVcard[0]}${dataVcard[1]}$contactName$counter\n${dataVcard[2]}$contactName$counter\n${dataVcard[3]}$number\n${dataVcard[4]}${dataVcard[5]}";
    } catch (e, s) {
      print(e);
      print(s);
      return "";
    }
  }
}
