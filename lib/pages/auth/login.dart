// ignore_for_file: prefer_final_fields
import 'dart:async';
import 'package:etourdiary/pages/auth/signup.dart';
import 'package:etourdiary/pages/home.dart';
import 'package:etourdiary/pages/splash_screen.dart';
import 'package:etourdiary/services/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:etourdiary/animations/customAnimation.dart';
import 'package:etourdiary/pages/auth/forgot.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isVisible = false;

  //auth service obj
  final AuthService _auth = AuthService();

  //Text Controllers
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  int _loginAttempts = 0;
  bool _loginButtonEnabled = true;
  DateTime? _loginButtonDisabledUntil;

  @override
  void initState() {
    super.initState();
    _loadLoginAttempts();
    _loadLoginButtonEnabled();
    _loadLoginButtonDisabledUntil();
  }
  

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
              padding: EdgeInsets.only(
                left: 35,
                top: MediaQuery.of(context).size.height * 0.2,
              ),
              child: const Text(
                'e-DANIKI',
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
                                  ? const Icon(Icons.visibility,
                                      color: Colors.black)
                                  : const Icon(Icons.visibility_off,
                                      color: Colors.black),
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
                            icon:
                                const Icon(Icons.password, color: Colors.black),
                            hintStyle:   const TextStyle(letterSpacing: 2.0),
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
                              onPressed: _loginButtonEnabled
                                  ? () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            String? errorMessage = await _auth
                                                .signInWithEmailAndPassword(
                                                    _email.text,
                                                    _password.text);
                                            if (errorMessage != null) {
                                              _incrementLoginAttempts();
                                              if (_loginAttempts >= 3) {
                                                _disableLoginButton();
                                                _startCountdownTimer();
                                              }
                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(errorMessage),
                                                  backgroundColor: Colors.red,
                                                  duration: const Duration( seconds: 3),
                                                ),
                                              );
                                            }
                                            print(errorMessage);
                                            if (errorMessage == null) {
                                              var sharedPref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              sharedPref.setBool(
                                                  SplashScreenState.KEYLOGIN,
                                                  true);
                                              _resetLoginAttempts();
                                              _resetLoginButtonDisabledUntil();
                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacement(
                                                  context,
                                                  ForwardPageRoute(
                                                      child: const Home()));
                                            }
                                          }
                                        }
                                        : null,
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(30),
                                  backgroundColor: Colors.black),
                              child: const Icon(Icons.arrow_forward_ios)),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => {
                              Navigator.pushReplacement(
                                  context, ForwardPageRoute(child: Signup()))
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () => {
                              Navigator.pushReplacement(
                                  context, ForwardPageRoute(child: const ForgotPassword()))
                            },
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  color: Colors.black),
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

  //
  Future<void> _loadLoginAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _loginAttempts = prefs.getInt('loginAttempts') ?? 0;
    });
  }
  Future<void> _saveLoginAttempts(int loginAttempts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('loginAttempts', loginAttempts);
  }

  Future<void> _loadLoginButtonEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _loginButtonEnabled = prefs.getBool('loginButtonEnabled') ?? true;
    });
  }

  Future<void> _saveLoginButtonEnabled(bool loginButtonEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginButtonEnabled', loginButtonEnabled);
  }

  Future<void> _loadLoginButtonDisabledUntil() async {
    final prefs = await SharedPreferences.getInstance();
    final loginButtonDisabledUntilTimestamp =
        prefs.getInt('loginButtonDisabledUntil');
    setState(() {
      _loginButtonDisabledUntil = loginButtonDisabledUntilTimestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(
              loginButtonDisabledUntilTimestamp)
          : null;
    });
    if (_loginButtonDisabledUntil != null) {
      _startCountdownTimer();
    }
  }

  Future<void> _saveLoginButtonDisabledUntil(
      DateTime loginButtonDisabledUntil) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('loginButtonDisabledUntil',
        loginButtonDisabledUntil.millisecondsSinceEpoch);
  }

  void _incrementLoginAttempts() async {
    setState(() {
      _loginAttempts++;
    });
    await _saveLoginAttempts(_loginAttempts);
  }

  void _resetLoginAttempts() async {
    setState(() {
      _loginAttempts = 0;
    });
    await _saveLoginAttempts(_loginAttempts);
  }

  void _disableLoginButton() async {
    setState(() {
      _loginButtonEnabled = false;
      _loginButtonDisabledUntil = DateTime.now().add(Duration(seconds: 15));
    });
    await _saveLoginButtonEnabled(false);
    await _saveLoginButtonDisabledUntil(_loginButtonDisabledUntil!);
  }

  void _resetLoginButtonDisabledUntil() async {
    setState(() {
      _loginButtonEnabled = true;
      _loginButtonDisabledUntil = null;
    });
    await _saveLoginButtonEnabled(true);
    await _saveLoginButtonDisabledUntil(DateTime.now());
  }

  void _startCountdownTimer() {
    Timer(
      Duration(
          milliseconds: _loginButtonDisabledUntil!
              .difference(DateTime.now())
              .inMilliseconds),
      _resetLoginButtonDisabledUntil,
    );
  }
}
