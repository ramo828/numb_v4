import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'themes/model_theme.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
          return MaterialApp(
            theme: themeNotifier.isDark
                ? ThemeData(
                    scaffoldBackgroundColor: Colors.brown.shade100,
                    brightness: Brightness.light,
                    appBarTheme: const AppBarTheme(),
                  )
                : ThemeData(
                    brightness: Brightness.dark,
                    appBarTheme: const AppBarTheme(
                      color: Colors.black,
                    ),
                  ),
            debugShowCheckedModeBanner: false,
            home: LoginScreen(),
          );
        },
      ),
    ),
  );
}
