import 'package:flutter/material.dart';
import 'package:number_seller/pages/active_/active_widgets.dart';

class active_page extends StatefulWidget {
  const active_page({super.key});

  @override
  State<active_page> createState() => _active_pageState();
}

class _active_pageState extends State<active_page> {
  double _progress = 0.0; // İlerleme değeri
  int max = 100;

// İlerleme çubuğunu güncellemek için kullanılan fonksiyon
  void _updateProgress() {
    if (_progress < max) {
      setState(() {
        _progress++; // İlerleme değerini artır
        // print(formatNumber(_progress));
      });
      // Bir sonraki adımı geciktirerek simüle ediyoruz (örneğin, 1 saniye)
      Future.delayed(Duration(seconds: 1), _updateProgress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            'İlerleme: ${((_progress / max) * 100.0).toInt()}%'), // İlerleme değerini göster
        Container(
          width: 260,
          height: 20,
          child: RoundedProgressBar(
              progressColor: Colors.brown,
              height: 2.5,
              value: _progress / 100.0,
              backgroundColor: Colors.brown.shade800.withOpacity(0.2)),
        ),
        OutlinedButton(
            onPressed: () {
              if (_progress == 1000) _progress = 0;
              _updateProgress();
            },
            child: Text("Yüklə")),
      ],
    );
  }
}
