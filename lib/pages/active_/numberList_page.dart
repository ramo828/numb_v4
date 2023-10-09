import 'package:flutter/material.dart';
import 'package:number_seller/pages/number_/background/active_function.dart';
import 'package:number_seller/pages/number_/background/work_functions.dart';
import 'package:number_seller/pages/number_/models/active_model.dart';
import 'package:provider/provider.dart';

class MyDataTable extends StatefulWidget {
  const MyDataTable({super.key});

  @override
  State<MyDataTable> createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  List<Map<String, dynamic>> mapList = [];
  // Listeden gelen değerler
  FirebaseFunctions ff = FirebaseFunctions();
  TextEditingController tec = TextEditingController(text: "xxxxxxxxx");
  String pattern = "xxxxxxxxx";
  bool uncorrect = false;
  @override
  Widget build(BuildContext context) {
    final isStatus = Provider.of<ActiveProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              onPressed: () {
                showPopup(context);
              },
              icon: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(
                  Icons.search,
                  size: 35,
                ),
              ),
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Number Seller',
            style: TextStyle(
              fontFamily: 'Handwriting',
              fontSize: 30,
              color: Colors.brown.withOpacity(0.9),
            ),
          ),
        ),
      ),
      body: ListView(children: [
        FutureBuilder<List<String>>(
            future:
                ff.loadNumberDataUser(isStatus.selectedOperator.toLowerCase()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator(); // Veriler yüklenene kadar bekleme göstergesi göster
              } else if (snapshot.hasError) {
                return Text('Hata: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('Veri bulunamadı');
              } else {
                // Verileri kullanarak bir arayüz oluşturun
                List<String> yeniData = [];
                for (String yeniNomreler in snapshot.data!) {
                  yeniData.add(yeniNomreler.substring(3, yeniNomreler.length));
                }

                List<String> data = findMatchingPatterns(pattern, yeniData);
                mapList.clear();
                for (int i = 0; i < data.length; i++) {
                  mapList.add({'id': i, 'number': data[i]});
                }
                // Örneğin, verileri bir liste olarak görüntülemek için ListView.builder kullanabilirsiniz
                return PaginatedDataTable(
                  header: const Center(
                    child: Text(
                      'Yeni əlavə edilən nömrələr',
                      style: TextStyle(
                        fontFamily: "Handwriting",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  rowsPerPage: 11,
                  columns: [
                    DataColumn(
                      label: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10.0), // Yuvarlak köşeleri ayarlayın
                        child: Container(
                          color: Colors.brown.shade100.withOpacity(0.3),
                          child: const Text(
                            'ID',
                            style: TextStyle(
                              fontFamily: "Lobster",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10.0), // Yuvarlak köşeleri ayarlayın
                        child: Container(
                          color: Colors.brown.shade100.withOpacity(0.3),
                          child: const Text(
                            'Nömrələr',
                            style: TextStyle(
                              fontFamily: "Lobster",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10.0), // Yuvarlak köşeleri ayarlayın
                        child: Container(
                          color: Colors.brown.shade100.withOpacity(0.3),
                          child: GestureDetector(
                            onTap: () {
                              func f = func();
                              f.shareList(isStatus.newNumberList);
                            },
                            child: const Text(
                              'Paylaş',
                              style: TextStyle(
                                fontFamily: "Lobster",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  source: MyDataTableSource(data: mapList, context: context),
                );
              }
            }),
      ]),
    );
  }

  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Axtar'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                pattern = value;
              });
            },
            minLines: 1,
            maxLength: 9,
            controller: tec,
            decoration: const InputDecoration(
              hintText: 'xxxxxxxxx',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Bağla'),
            ),
          ],
        );
      },
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final BuildContext context;
  MyDataTableSource({
    required this.data,
    required this.context,
  });

  @override
  DataRow? getRow(int index) {
    final isStatus = Provider.of<ActiveProvider>(context, listen: true);

    if (index >= data.length) return null;
    final user = data[index];
    return DataRow(cells: [
      DataCell(ClipRRect(
        borderRadius:
            BorderRadius.circular(10.0), // Yuvarlak köşeleri ayarlayın
        child: Container(
          color: Colors.brown.shade100.withOpacity(0.2),
          child: Text(
            user['id'].toString(),
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
      )),
      DataCell(ClipRRect(
        borderRadius:
            BorderRadius.circular(10.0), // Yuvarlak köşeleri ayarlayın
        child: Container(
          color: Colors.brown.shade100.withOpacity(0.2),
          child: Text(
            user['number'],
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
      )),
      DataCell(
        IconButton(
          icon: Icon(
            isStatus.getNewNumberCheckStatusAtIndex(index)
                ? Icons.cancel
                : Icons.check,
            color: isStatus.getNewNumberCheckStatusAtIndex(index)
                ? Colors.red
                : Colors.green,
          ),
          onPressed: () {
            // IconButton'a tıklandığında seçimi değiştir
            isStatus.updateNewNumberCheckStatus(
                !isStatus.getNewNumberCheckStatusAtIndex(index), index);
            print('Seçilen: ${isStatus.getNewNumberCheckStatusAtIndex(index)}');
            if (isStatus.getNewNumberCheckStatusAtIndex(index)) {
              isStatus.updateNewNumberList(user['number']);
              print(isStatus.newNumberList);
            } else {
              isStatus.removeNewNumberList(user['number']);
              print(isStatus.newNumberList);
            }
          },
        ),
      )
    ]);
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
