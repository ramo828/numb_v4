import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;
import '../number_/backend/number_constant.dart';

class activeNetwork {
  Future<bool> activeNumbers(String number) async {
    try {
      var response = await http.get(
        getActiveNar(number),
        headers: await getHeaders(1),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 403) {
        throw Exception("Key xətası ${response.statusCode}");
      } else {
        return false;
      }
    } catch (e) {
      Exception(e);
      return false;
    }
  }

  Future<bool> activeNUmbersBakcell(String number, String prefix) async {
    try {
      var response = await http.get(
        getBakcell(number, "", 0, prefix, true),
        headers: await getHeaders(0),
      );
      if (response.statusCode == 500) {
        throw Exception("Key xətası");
      }
      if (response.statusCode == 200) {
        var data = loadData(response.body);
        List msis = data[0]['freeMsisdnList'];
        if (msis.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
      // ignore: empty_catches
    } catch (e) {
      Exception(e);
      return false;
    }
  }

  Future<bool> activeAzercell(
    String number,
    String prefixKey,
  ) async {
    bool numberActiveStatus = false;
    print(prefixKey);
    try {
      var response = await http.post(
        getAzercell("0"),
        headers: azercellHeader,
        body: {
          "prefix": prefixKey == "99450"
              ? "50"
              : prefixKey == "99451"
                  ? "51"
                  : prefixKey == "99410"
                      ? "10"
                      : "90",
          "num1": number[0],
          "num2": number[1],
          "num3": number[2],
          "num4": number[3],
          "num5": number[4],
          "num6": number[5],
          "num7": number[6],
          "send_search": "1",
        },
      );

      BeautifulSoup bs = BeautifulSoup(
        response.body,
      );

      var find = bs.findAll("div", attrs: {"class": "phonenumber"});
      if (find.isEmpty) {
        numberActiveStatus = true;
      } else {
        numberActiveStatus = false;
      }
    } catch (e) {
      print("$e");
    }
    return numberActiveStatus;
  }
}
