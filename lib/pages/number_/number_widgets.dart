import 'package:number_seller/pages/number_/models/number_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> prefixList = [];

// Initial Selected Value
String defaultOperation = 'Köhnə baza';
String defaultOperator = 'Bakcell';
String defaultOperator1 = 'Nar';

String defaultPrefix = '055';
String defaultPrefix1 = '070';

String defaultCategory = 'Hamısı';

// List<String> categoryDefault = ['Hamısı'];
List<String> category055 = [
  'Hamısı',
  'Sadə',
  'Xüsusi 1',
  'Xüsusi 2',
];
List<String> category099 = [
  'Hamısı',
  'Sadə',
  'Bürünc',
  'Gümüş',
  'Qızıl',
  'Platin'
];

List<String> categoryNar = [
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
// List of items in our dropdown menu
List<String> operators = [
  'Bakcell',
  'Nar',
];
// List of items in our dropdown menu
List<String> operators1 = [
  'Nar',
  'Bakcell',
];

// List of items in our dropdown menu
List<String> operation = ['Köhnə baza', 'Yeni baza', 'Hesablama'];
// List of items in our dropdown menu
List<String> prefixBakcell = [
  '055',
  '099',
];
List<String> prefixNar = [
  '070',
  '077',
];

List<String> allItems = [
  '055',
  '099',
  '050',
  '051',
  '010',
  '070',
  '077',
];

final List<String> fileFomrat = ['Text', 'VCF', 'VCF(Zip)']; // Dropdown öğeleri
String selectFileFormat = "Text";

class WorkElements extends StatefulWidget {
  final int level;
  const WorkElements({
    super.key,
    required this.level,
  });

  @override
  State<WorkElements> createState() => _WorkElementsState();
}

class _WorkElementsState extends State<WorkElements> {
  @override
  Widget build(BuildContext context) {
    final selectedOperator = Provider.of<OperatorProvider>(context);

    return Column(
      children: [
        CustomDropdownButton(
            dropName: "Operator",
            dropdownValue: defaultOperator,
            items: operators,
            disableItem: widget.level < 1 ? "Nar" : "",
            onChanged: (String? newValue) {
              selectedOperator.updateSelectedOperator(newValue!);
              setState(() {
                defaultOperator = newValue;
                if (defaultOperator.contains("Bakcell")) {
                  defaultPrefix = "055";
                } else {
                  defaultPrefix = "070";
                }
                selectedOperator.updateSelectedPrefix(defaultPrefix);
              });
            }),
        CustomDropdownButton(
            dropName: "Prefix",
            dropdownValue: defaultPrefix,
            items:
                defaultOperator.contains("Bakcell") ? prefixBakcell : prefixNar,
            onChanged: (String? newValue) {
              selectedOperator.updateSelectedPrefix(newValue!);
              setState(() {
                defaultPrefix = newValue;
                defaultCategory = "Hamısı";
              });
            }),
        CustomDropdownButton(
            dropName: "Kategoriya",
            dropdownValue: defaultCategory,
            disableItem: widget.level < 1 ? "Bürünc" : "",
            items: defaultPrefix.contains("055")
                ? category055
                : defaultPrefix.contains("099")
                    ? category099
                    : categoryNar,
            onChanged: (String? newValue) {
              selectedOperator.updateSelectedCategory(newValue!);
              setState(() {
                defaultCategory = newValue;
              });
            }),
        DropdownButton<String>(
          hint: const Text(
            'Hazırlanacaq prefixlər',
            style: TextStyle(
              fontFamily: "Lobster",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // value: '055',
          items: allItems.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: SizedBox(
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
        CustomDropdownButton(
            dropdownValue: selectFileFormat,
            items: fileFomrat,
            onChanged: (String? myValue) {
              selectedOperator.updateSelectedFileType(myValue!);
              setState(() {
                selectFileFormat = myValue;
              });
            },
            dropName: "Fayl tipi")
      ],
    );
  }
}

class MyCheckboxListTile extends StatefulWidget {
  final String item;

  const MyCheckboxListTile({super.key, required this.item});

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
          saveBoolValue(widget.item, value);

          if (value) {
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

class CustomDropdownButton extends StatelessWidget {
  final String dropdownValue;
  final List<String> items;
  final Function(String?) onChanged;
  final bool enableStatus;
  final String disableItem;
  final String dropName;

  const CustomDropdownButton({
    super.key,
    required this.dropdownValue,
    required this.items,
    required this.onChanged,
    required this.dropName,
    this.enableStatus = true,
    this.disableItem = "",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "$dropName: ",
            style: const TextStyle(
              fontFamily: "Lobster",
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DropdownButton(
          value: dropdownValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((String item) {
            return DropdownMenuItem(
              enabled: disableItem.contains(item) ? false : true,
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: disableItem.contains(item) ? Colors.red : Colors.black,
                ),
              ),
            );
          }).toList(),
          onChanged: enableStatus ? onChanged : null,
        ),
      ],
    );
  }
}

const underlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.transparent),
  // Çizgiyi şeffaf yapar
);
