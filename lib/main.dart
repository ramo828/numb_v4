import 'package:number_seller/pages/number_/models/index_models.dart';
import 'package:number_seller/pages/number_/models/loading_models.dart';
import 'package:number_seller/pages/number_/models/number_models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/number_/background/firebase_options.dart'; // Firebase yapılandırma dosyanızı ekleyin
import 'pages/number_/models/model_theme.dart'; // ModelTheme'ı içeren dosyanızı ekleyin
import 'pages/first_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelTheme(),
        ),
        ChangeNotifierProvider(
          create: (context) => OperatorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoadingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => indexProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
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
          home: const First(),
        );
      },
    );
  }
}
