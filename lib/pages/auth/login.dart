import 'package:etourdiary/pages/auth/signup.dart';
import 'package:etourdiary/pages/home.dart';
import 'package:etourdiary/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      // backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 170),
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 60, letterSpacing: 2.0),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.43,
                    left: 35,
                    right: 35),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Email',
                          hintStyle: const TextStyle(letterSpacing: 2.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
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
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isVisible = !_isVisible;
                              });
                            },
                          ),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Password',
                          hintStyle: const TextStyle(letterSpacing: 2.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String? errorMessage =
                              await _auth.signInWithEmailAndPassword(
                                  _email.text, _password.text);
                          if (errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                          print(errorMessage);
                          if (errorMessage == null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => Home()));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 60),
                          textStyle: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500)),
                      child: const Text(
                        'Login',
                        style: TextStyle(letterSpacing: 2.0),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => Signup()))
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
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
    );
  }
}
