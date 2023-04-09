import 'package:etourdiary/pages/auth/login.dart';
import 'package:etourdiary/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isVisible = false;
  bool _isVisible2 = false;
  bool n = false, em = false, p = false, cp = false;
  final AuthService _auth = AuthService();
  // text Controllers
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[800],
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 100),
            child: const Text(
              'Signup',
              style: TextStyle(
                fontSize: 60,
                letterSpacing: 2.0,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28,
                    left: 35,
                    right: 35),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Name',
                          hintStyle: const TextStyle(letterSpacing: 2.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else if (!RegExp(
                                r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$")
                            .hasMatch(value)) {
                          return "Enter correct name";
                        } else {
                          n = true;
                        }
                      },
                    ),
                    const SizedBox(height: 30),
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
                        } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                            .hasMatch(value)) {
                          return "Please enter a Valid Email";
                        } else {
                          em = true;
                        }
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
                        } else if (!RegExp(
                                r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$")
                            .hasMatch(value)) {
                          return "Min 8 characters, atleast 1 uppercase letter,\n1 lowercase letter, 1 number and 1 special character";
                        } else {
                          p = true;
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _confirmPassword,
                      obscureText: !_isVisible2,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: _isVisible2
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isVisible2 = !_isVisible2;
                              });
                            },
                          ),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Confirm Password',
                          hintStyle: const TextStyle(letterSpacing: 2.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else if (!RegExp(
                                r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$")
                            .hasMatch(value)) {
                          return "Min 6 characters, atleast 1 uppercase letter,\n1 lowercase letter, 1 number and 1 special character";
                        } else if (value != _password.text) {
                          return 'Password does not match';
                        } else {
                          cp = true;
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String? errorMessage =
                              await _auth.signUpWithEmailAndPassword(
                                  _email.text, _password.text, _name.text);
                          if (errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else if (n && em && p && cp) {
                            _email.clear();
                            _name.clear();
                            _password.clear();
                            _confirmPassword.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Account Successfully Created.'),
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 60),
                          textStyle: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500)),
                      child: const Text(
                        'Signup',
                        style: TextStyle(letterSpacing: 2.0),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => Login()))
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                            ),
                          ),
                        ),
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
