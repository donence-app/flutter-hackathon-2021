import 'package:donence_app/screens/add_book_page.dart';
import 'package:donence_app/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Google SignIn';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepPurple,
          fontFamily: 'Poppins',
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
        ),
        themeMode: ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/': (context) => LandingPage(),
          // '/search': (context) => SearchPage(),
          '/add_manual': (context) => AddBookPage(),
        },
      );
}
