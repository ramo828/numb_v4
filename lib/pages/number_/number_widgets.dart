import 'package:e_com/pages/number_/models/number_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

class myDropCollections extends StatefulWidget {
  const myDropCollections({super.key});

  @override
  State<myDropCollections> createState() => _myDropCollectionsState();
}

class _myDropCollectionsState extends State<myDropCollections> {
  String operatorSelectedItem = 'Azərcell';
  String categorySelectedItem = 'Hamısı';
  String prefixSelectedItem = '050';

  final List<String> operators = [
    'Azərcell',
    'Bakcell',
    'Nar',
  ];
  List<String> prefixDefault = [
    '050',
    '051',
    '010',
  ];
  List<String> categoryDefault = ['Hamısı'];
  final List<String> categoryAzercell = ['Hamısı'];
  final List<String> categoryBakcell055 = [
    'Sadə',
    'Xüsusi 1',
    'Xüsusi 2',
  ];
  final List<String> categoryBakcell099 = [
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
        DropdownButton<String>(
          value: operatorSelectedItem,
          onChanged: (value) {
            selectedOperator.updateSelectedOperator(value ?? '');
            setState(() {
              operatorSelectedItem = value!;
              if (value.contains("Azercell")) {
                prefixDefault = prefixAzercell;
                prefixSelectedItem = '050';
                categoryDefault = categoryAzercell;
                categorySelectedItem = "Hamısı";
              } else if (value.contains("Bakcell")) {
                prefixDefault = prefixBakcell;
                prefixSelectedItem = '055';
                categoryDefault = categoryBakcell055;
                categorySelectedItem = "Sadə";
              } else {
                prefixDefault = prefixNar;
                prefixSelectedItem = '070';
                categoryDefault = categoryNar;
                categorySelectedItem = "GENERAL";
              }
            });
          },
          items: operators.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
              enabled: item.contains("Azərcell")
                  ? false
                  : item.contains("Nar")
                      ? false
                      : true,
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        DropdownButton<String>(
          value: prefixSelectedItem,
          onChanged: operatorSelectedItem.contains("Azərcell")
              ? null
              : operatorSelectedItem.contains("Nar")
                  ? null
                  : (value) {
                      selectedOperator.updateSelectedPrefix(value ?? '');

                      setState(() {
                        prefixSelectedItem = value!;
                        print(value);
                        if (value.contains("050") ||
                            value.contains("051") ||
                            value.contains("010")) {
                          categoryDefault = categoryAzercell;
                          categorySelectedItem = "Hamısı";
                        } else if (value.contains("055")) {
                          categoryDefault = categoryBakcell055;
                          categorySelectedItem = "Sadə";
                        } else if (value.contains("099")) {
                          categoryDefault = categoryBakcell099;
                          categorySelectedItem = "Sadə099";
                        } else if (value.contains("070") ||
                            value.contains("077")) {
                          categoryDefault = categoryNar;
                          categorySelectedItem = "GENERAL";
                        }
                        print(categoryDefault);
                      });
                    },
          items: prefixDefault.map<DropdownMenuItem<String>>((String item1) {
            return DropdownMenuItem<String>(
              value: item1,
              child: Text(item1),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        DropdownButton<String>(
          value: categorySelectedItem,
          onChanged: operatorSelectedItem.contains("Azərcell")
              ? null
              : operatorSelectedItem.contains("Nar")
                  ? null
                  : (value) {
                      selectedOperator.updateSelectedCategory(value ?? '');

                      setState(() {
                        categorySelectedItem = value!;
                      });
                    },
          items: categoryDefault.map<DropdownMenuItem<String>>((String item1) {
            return DropdownMenuItem<String>(
              value: item1,
              child: Text(item1),
            );
          }).toList(),
        ),
      ],
    );
  }
}

final ssnMaskFormatter = TextInputFormatter.withFunction(
  (TextEditingValue oldValue, TextEditingValue newValue) {
    // Mask ve filtreleme mantığını burada uygulayın
    // Bu örnekte, yalnızca rakam veya 'x' veya 'X' karakterlerini kabul ediyoruz
    final filteredText = newValue.text.replaceAll(RegExp(r'[^0-9xX]'), '');

    // Maskı uygula (###-##-##)
    final maskedText = StringBuffer();
    var index = 0;
    for (var i = 0; i < filteredText.length; i++) {
      if (index >= 7)
        break; // Format "###-##-##" olduğu için indeksi 8'e düşürdük
      if (filteredText[i] == 'x' || filteredText[i] == 'X') {
        if (index == 3 || index == 5) {
          // İndeks 3 ve 5'te "-" eklemesi
          maskedText.write('-');
        }
        maskedText.write(filteredText[i]);
      } else {
        maskedText.write(filteredText[i]);
        if (index == 2 || index == 4) {
          // İndeks 2 ve 4'te "-" eklemesi
          maskedText.write('-');
        }
      }
      index++;
    }

    return TextEditingValue(
      text: maskedText.toString(),
      selection: TextSelection.collapsed(offset: maskedText.length),
    );
  },
);

const underlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.transparent),
  // Çizgiyi şeffaf yapar
);
