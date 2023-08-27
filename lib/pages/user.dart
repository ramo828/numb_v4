import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "workController.dart";

class user_info extends StatelessWidget {
  String getEmailUsername(String email) {
    List<String> parts = email.split('@');
    if (parts.length > 1) {
      return parts[0];
    }
    return email; // Eğer "@" işareti yoksa, tüm emaili geri döndür
  }

  final String username;

  user_info({required this.username});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(getEmailUsername(username))
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        int? level = snapshot.data!.get('level') as int?;
        return workControl(
          level: level ?? 0,
        );
      },
    );
  }
}
