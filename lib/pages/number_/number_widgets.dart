import 'package:number_seller/pages/number_/background/work_functions.dart';
import 'package:number_seller/pages/number_/models/number_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class myDropCollections extends StatefulWidget {
  const myDropCollections({super.key});

  @override
  State<myDropCollections> createState() => _myDropCollectionsState();
}

class _myDropCollectionsState extends State<myDropCollections> {
  final List<String> fileFomrat = [
    'Text',
    'VCF',
    'VCF(Zip)'
  ]; // Dropdown öğeleri
  String selectFileFormat = "Text";

  // String operatorSelectedItem = 'Azərcell';
  String operatorSelectedItem = 'Bakcell';

  String categorySelectedItem = 'Hamısı';
  // String prefixSelectedItem = '050';
  String prefixSelectedItem = '055';

  final List<String> operators = [
    // 'Azərcell',
    'Bakcell',
    'Nar',
  ];
  // List<String> prefixDefault = [
  //   '050',
  //   '051',
  //   '010',
  // ];

  List<String> prefixDefault = [
    '055',
    '099',
  ];

  // List<String> categoryDefault = ['Hamısı'];
  List<String> categoryDefault = [
    'Hamısı',
    'Sadə',
    'Xüsusi 1',
    'Xüsusi 2',
  ];

  // final List<String> categoryAzercell = ['Hamısı'];
  final List<String> categoryBakcell055 = [
    'Hamısı',
    'Sadə',
    'Xüsusi 1',
    'Xüsusi 2',
  ];
  final List<String> categoryBakcell099 = [
    'Hamısı',
    'Sadə099',
    'Bürünc',
    'Gümüş',
    'Qızıl',
    'Platin'
  ];

  final List<String> categoryNar = [
    'GENERAL',
    'Prestige',
    'Prestige1',
    'Prestige2',
    'Prestige3',
    'Prestige4',
    'Prestige5',
    'Prestige6',
    'Prestige7',
    'Prestige8',
    'Hamısı',
  ];

  final List<String> prefixAzercell = [
    '050',
    '051',
    '010',
  ];
  final List<String> prefixBakcell = [
    '055',
    '099',
  ];
  final List<String> prefixNar = [
    '070',
    '077',
  ];

  List<String> allItems = ['055', '099', '050', '051', '010', '070', '077'];

  @override
  Widget build(BuildContext context) {
    final selectedOperator = Provider.of<OperatorProvider>(context);
    setState(() {});
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Operator: "),
            DropdownButton<String>(
              value: operatorSelectedItem,
              onChanged: (value) {
                selectedOperator.updateSelectedOperator(value ?? '');
                setState(() {
                  prefixDefault = prefixBakcell;
                  prefixSelectedItem = "055";
                  categoryDefault = categoryBakcell055;
                });
              },
              items: operators.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  enabled: item.contains("Azərcell")
                      ? false
                      : item.contains("Nar")
                          ? false
                          : true,
                  child: Text(item),
                );
              }).toList(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Prefix: "),
            DropdownButton<String>(
              value: prefixSelectedItem,
              onChanged: (value) {
                selectedOperator.updateSelectedPrefix(value ?? '');
                setState(() {
                  prefixSelectedItem = value ?? '';
                  categoryDefault = value!.contains("055")
                      ? categoryBakcell055
                      : categoryBakcell099;
                });
                print(prefixSelectedItem);
              },
              items:
                  prefixDefault.map<DropdownMenuItem<String>>((String item1) {
                return DropdownMenuItem<String>(
                  value: item1,
                  child: Text(item1),
                );
              }).toList(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Kategoriya: "),
            DropdownButton<String>(
              value: categorySelectedItem,
              onChanged: (value) {
                setState(() {
                  categorySelectedItem = value ?? "";
                });
                selectedOperator.updateSelectedCategory(value ?? '');
              },
              items:
                  categoryDefault.map<DropdownMenuItem<String>>((String item1) {
                return DropdownMenuItem<String>(
                  value: item1,
                  child: Text(item1),
                );
              }).toList(),
            ),
          ],
        ),
        DropdownButton<String>(
          hint: Text('Hazırlanacaq prefixlər: '),
          // value: '055',
          items: allItems.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Container(
                width: 200,
                child: ListView(
                  children: [MyCheckboxListTile(item: item)],
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            // Dropdown değeri değiştiğinde burada işlem yapabilirsiniz.
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Fayl format: "),
            DropdownButton<String>(
              value: selectFileFormat, // Başlangıç değeri (ilk öğe)
              items: fileFomrat.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item), // Öğe metni
                );
              }).toList(),
              onChanged: (selectedValue) {
                selectedOperator.updateSelectedFileType(selectedValue!);
                setState(() {
                  selectFileFormat = selectedValue ?? '';
                });
              },
            ),
          ],
        )
      ],
    );
  }
}

List<String> prefixList = [];

const underlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.transparent),
  // Çizgiyi şeffaf yapar
);

class MyCheckboxListTile extends StatefulWidget {
  final String item;

  MyCheckboxListTile({required this.item});

  @override
  _MyCheckboxListTileState createState() => _MyCheckboxListTileState();
}

class _MyCheckboxListTileState extends State<MyCheckboxListTile> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    bool initialValue = prefs.getBool(widget.item) ?? false;
    setState(() {
      data[widget.item] = initialValue;
    });
  }

  Map<String, bool> data = {};

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.item),
      value: data[widget.item] ?? false,
      onChanged: (value) {
        setState(() {
          data[widget.item] = value!;
          saveBoolValue(widget.item, value!);

          if (value!) {
            // Seçildiğinde yapılması gereken işlemler
            if (!prefixList.contains(widget.item)) {
              if (widget.item.contains('050')) {
                prefixList.add(widget.item.replaceAll("050", '+99450'));
              } else if (widget.item.contains('010')) {
                prefixList.add(widget.item.replaceAll("010", '+99410'));
              } else if (widget.item.contains('070')) {
                prefixList.add(widget.item.replaceAll('070', '+99470'));
              } else {
                prefixList.add(widget.item.replaceAll('0', '+994'));
              }
            }
          } else {
            if (!prefixList.contains(widget.item)) {
              if (widget.item.contains('050')) {
                prefixList.remove(widget.item.replaceAll("050", '+99450'));
              } else if (widget.item.contains('010')) {
                prefixList.remove(widget.item.replaceAll("010", '+99410'));
              } else if (widget.item.contains('070')) {
                prefixList.remove(widget.item.replaceAll('070', '+99470'));
              } else {
                prefixList.remove(widget.item.replaceAll('0', '+994'));
              }
            }
          }
          print(prefixList);
          saveStringList("addPrefix", prefixList);
        });
      },
      selected: data[widget.item] ?? false,
    );
  }

  Future<void> saveBoolValue(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  Future<void> saveStringList(String key, List<String> value) async {
    await prefs.setStringList(key, value);
  }
}
