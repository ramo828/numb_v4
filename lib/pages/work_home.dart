import 'package:e_com/themes/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'user.dart';

class home_page extends StatefulWidget {
  // const home_page({super.key});
  final String email;
  home_page({
    super.key,
    required this.email,
  });

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () {
                  themeNotifier.isDark
                      ? themeNotifier.isDark = false
                      : themeNotifier.isDark = true;
                },
                child: Icon(
                  themeNotifier.isDark ? Icons.sunny : FontAwesomeIcons.moon,
                  size: 35,
                ),
              ),
            )
          ],
          title: Text("Second app"),
        ),
        body: user_info(
          username: widget.email,
        ),
      );
    });
  }
}
