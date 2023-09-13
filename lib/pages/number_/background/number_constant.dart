import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:number_seller/pages/number_/background/work_functions.dart';

List<dynamic> loadData(String jsonData) => json.decode(jsonData).toList();

Future<Map<String, String>> getHeaders(int choise) async {
  String key = "";

  List<String>? setting = await getStringList('keys') ?? [];
  if (choise == 0) {
    key = setting[0];
    print(key);
  } else {
    key = setting[1];
    print(key);
  }
  return {
    'Content-Type': 'application/json',
    'Accept': 'application/json, text/plain, */*',
    'Authorization': key,
    'User-Agent':
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36',
    'Referer': 'https://nomre.bakcell.com/',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Credentials': 'true',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
  };
}

Map<String, String> azercellHeader = {
  "cache-control": "no-store, no-cache, must-revalidate",
  "content-encoding": "gzip",
  "date": "Sat, 08 Oct 2022 21:30:48 GMT",
  "expires": "Thu, 19 Nov 1981 08:52:00 GMT",
  "pragma": "no-cache",
  "server": "nginx",
  "x-country": "Azerbaijan",
  "x-frame-options": "SAMEORIGIN",
  // "content-length": "73",
};

Uri getAzercell(String page) {
  return Uri.parse(
    // ignore: unrelated_type_equality_checks
    "https://azercellim.com/az/search${page != 0 ? "/$page" : ""}",
  );
}

Uri getBakcell(
  String number,
  String categoryKey,
  int page,
  String prefix,
  bool all,
) {
  print("Category: $categoryKey");

  return Uri.https(
    "public-api.azerconnect.az",
    "/msbkcposappreservation/api/freemsisdn-nomre/search",
    !all
        ? {
            "prefix": prefix,
            "msisdn": number,
            "showReserved": "true",
            "size": "2000",
            "categoryId": getCategory(categoryKey),
            "page": "$page",
          }
        : {
            "prefix": prefix,
            "msisdn": number,
            "showReserved": "true",
            "size": "2000",
            "page": "$page",
          },
  );
}

// bunu duzelt
Uri getNar(String number, String prestigeKey, String prefixKey, int page) {
  print(prefixKey);
  List<String> num = [
    number[0] == 'x' ? '' : number[0],
    number[1] == 'x' ? '' : number[1],
    number[2] == 'x' ? '' : number[2],
    number[3] == 'x' ? '' : number[3],
    number[4] == 'x' ? '' : number[4],
    number[5] == 'x' ? '' : number[5],
    number[6] == 'x' ? '' : number[6]
  ];
  return Uri.https(
    "public-api.azerconnect.az",
    "/msazfposapptrans/api/msisdn-search",
    {
      "prefix": prefixKey,
      "msisdn": number,
      "size": "2000",
      "page": "$page",
      "prestigeLevel": prestigeKey,
      "a1": num[0],
      "a2": num[1],
      "a3": num[2],
      "a4": num[3],
      "a5": num[4],
      "a6": num[5],
      "a7": num[6],
    },
  );
}

Uri getActiveNar(String number) {
  return Uri.https(
    "public-api.azerconnect.az",
    "/msazfposappds/api/dealer/recharge-log/details/$number",
  );
}

String getCategory(String keyData) {
  Map<String, String> category = {
    "sadə": "1429263300716842758",
    "xüsusi 1": "1579692547752973099",
    "xüsusi 2": "1579692503636523114",
    // 099
    "sadə099": "1574940031138475856",
    "bürünc": "1582551518546595643",
    "gümüş": "1582551485948558941",
    "qızıl": "1582551461421619154",
    "platin": "1582551437850968791",
  };
  // ignore: unnecessary_null_comparison
  if (keyData == null) throw ("Null key");
  return category[keyData].toString();
}

class AutoKey {
  final String username;
  final String password;

  AutoKey(this.username, this.password);

  Future<String> getKey() async {
    final url = Uri.parse("https://public-api.azerconnect.az/api/authenticate");
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'username': username, 'password': password});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final key = jsonResponse['id_token'];
      return key.toString();
    } else {
      throw Exception('Failed to get key');
    }
  }
}
