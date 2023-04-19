import 'package:etourdiary/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'pages/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:etourdiary/pages/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
