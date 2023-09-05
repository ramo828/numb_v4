import 'package:flutter/material.dart';
import 'package:number_seller/pages/work_home.dart';

class notification extends StatefulWidget {
  final String message;
  final String title;
  final bool notifStatus;
  const notification({
    super.key,
    required this.notifStatus,
    required this.title,
    required this.message,
  });

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Number Seller',
              style: TextStyle(
                fontFamily: 'Handwriting',
                color: Colors.brown.withOpacity(0.9),
                fontSize: 30,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15, top: 10),
          child: my_container(
            width: 350,
            color: const Color.fromRGBO(141, 110, 99, 1).withOpacity(0.5),
            height: 700,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: 'Handwriting',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5, top: 5),
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      fontFamily: 'Handwriting',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
