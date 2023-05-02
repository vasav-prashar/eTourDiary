// ignore_for_file: prefer_final_fields

import 'package:etourdiary/pages/auth/signup.dart';
import 'package:etourdiary/pages/home.dart';
import 'package:etourdiary/pages/splash_screen.dart';
import 'package:etourdiary/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:etourdiary/animations/customAnimation.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isVisible=false;

  //auth service obj
  final AuthService _auth = AuthService();

  //Text Controllers
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login.png'), fit: BoxFit.fitWidth)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35,
              top: MediaQuery.of(context).size.height * 0.17,
              ),
              child: const Text(
                'Welcome\nBack',
                style: TextStyle(
                    fontSize: 50, letterSpacing: 2.0, color: Colors.white),
              ),
            ),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.45,
                      left: 35,
                      right: 35),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black),
                            icon: Icon(Icons.email, color: Colors.black),
                            hintStyle: TextStyle(letterSpacing: 2.0),
                            border: UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder()),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _password,
                        obscureText: !_isVisible,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: _isVisible
                                  ? const Icon(Icons.visibility, color: Colors.black)
                                  : const Icon(Icons.visibility_off, color: Colors.black),
                              onPressed: () {
                                setState(() {
                                  _isVisible = !_isVisible;
                                });
                              },
                            ),
                            fillColor: Colors.transparent,
                            filled: true,
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.black),
                            icon: const Icon(Icons.password, color: Colors.black),
                            hintStyle: const TextStyle(letterSpacing: 2.0),
                            border: const UnderlineInputBorder(),
                            focusedBorder: const UnderlineInputBorder()),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "SignIn",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.0,
                                color: Colors.black),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String? errorMessage =
                                    await _auth.signInWithEmailAndPassword(
                                        _email.text, _password.text);
                                if (errorMessage != null) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                }
                                print(errorMessage);
                                if (errorMessage == null) {
                                  var sharedPref =
                                      await SharedPreferences.getInstance();
                                  sharedPref.setBool(SplashScreenState.KEYLOGIN, true);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushReplacement(
                                      context,
                                      CustomPageRoute(child: const Home()));
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(30),
                                backgroundColor: Colors.black
                              ),
                            child: const Icon(Icons.arrow_forward_ios)
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => {
                              Navigator.pushReplacement(
                                      context,
                                      CustomPageRoute(child: Signup()))
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Colors.black
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => {},
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Colors.black
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
