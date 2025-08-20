import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/constants.dart';
import 'package:loja_virtual/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roupa Nova',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: corPrimaria,
        scaffoldBackgroundColor: Colors.white,
        drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: const Color.fromARGB(255, 53, 51, 51)),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
