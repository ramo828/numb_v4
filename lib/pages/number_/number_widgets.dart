import 'package:e_com/pages/number_/models/number_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class myDropCollections extends StatefulWidget {
  const myDropCollections({super.key});

  @override
  State<myDropCollections> createState() => _myDropCollectionsState();
}

class _myDropCollectionsState extends State<myDropCollections> {
  final List<String> fileFomrat = ['Text', 'VCF']; // Dropdown öğeleri
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

  @override
  Widget build(BuildContext context) {
    final selectedOperator = Provider.of<OperatorProvider>(context);

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

const underlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.transparent),
  // Çizgiyi şeffaf yapar
);
