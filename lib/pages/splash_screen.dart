// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:etourdiary/pages/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:etourdiary/pages/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  // ignore: constant_identifier_names
  static const String KEYLOGIN = "login";

  @override
  void initState() {
    super.initState();

    Destination();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: const Center(
          child: Text(
            "e-DANIKI",
            style: TextStyle(
                fontSize: 34, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void Destination() async {
    var sharedPref = await SharedPreferences.getInstance();

    var isLoggedIn = sharedPref.getBool(SplashScreenState.KEYLOGIN);

    Timer(const Duration(seconds: 2), () {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: ((context) => const Home())));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: ((context) => const Login())));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => const Login())));
      }
    });
  }
}
