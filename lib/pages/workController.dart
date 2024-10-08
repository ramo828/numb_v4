import 'package:flutter/material.dart';

// ignore: camel_case_types
class workControl extends StatefulWidget {
  final int level;

  const workControl({
    super.key,
    required this.level,
  });

  @override
  State<workControl> createState() => _workControlState();
}

class _workControlState extends State<workControl> {
  @override
  Widget build(BuildContext context) {
    if (widget.level == 0) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Sizin hesab dayandirilib",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      );
    } else if (widget.level == -1) {
      return const Center(
        child: Text(
          "Sizin aylıq ödənişinizin zamanı gəlmişdir",
        ),
      );
    } else {
      return const Scaffold(
        body: Text("Work page"),
      );
    }
  }
}
