// ignore_for_file: prefer_final_fields, use_build_context_synchronously
import 'package:etourdiary/pages/auth/login.dart';
import 'package:etourdiary/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:etourdiary/animations/customAnimation.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

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
    return Container(
      decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/register.png'),
                fit: BoxFit.fitWidth              
              )
            ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding:  EdgeInsets.only(left: 35,
                top: MediaQuery.of(context).size.height * 0.12,
                ),
                child: const Text(
                  'Create\nAccount',
                  style: TextStyle(
                    fontSize: 50,
                    letterSpacing: 2.0,
                    color: Colors.white
                  ),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.34,
                        left: 35,
                        right: 35),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              filled: true,
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.black),
                              icon: Icon(Icons.person,color: Colors.black),
                              
                              hintStyle: TextStyle(letterSpacing: 2.0),
                              border: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder()),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            } else if (!RegExp(
                                    r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$")
                                .hasMatch(value)) {
                              return "Enter a valid name";
                            } else {
                              n = true;
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _email,
                          decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              filled: true,
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.black),
                              icon: Icon(Icons.email,color: Colors.black),
                              hintStyle: TextStyle(letterSpacing: 2.0),
                              border: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder()),
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
                                    ? const Icon(Icons.visibility,color: Colors.black)
                                    : const Icon(Icons.visibility_off,color: Colors.black),
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
                              icon: const Icon(Icons.password,color: Colors.black),
                              hintStyle: const TextStyle(letterSpacing: 2.0),
                              border: const UnderlineInputBorder(),
                              focusedBorder: const UnderlineInputBorder()),
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
                                    ? const Icon(Icons.visibility,color: Colors.black)
                                    : const Icon(Icons.visibility_off,color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    _isVisible2 = !_isVisible2;
                                  });
                                },
                              ),
                              fillColor: Colors.transparent,
                              filled: true,
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(color: Colors.black),
                              icon: const Icon(Icons.password,color: Colors.black),
                              hintStyle: const TextStyle(letterSpacing: 2.0),
                              border: const UnderlineInputBorder(),
                              focusedBorder: const UnderlineInputBorder()),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            } else if (!RegExp(
                                    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$")
                                .hasMatch(value)&& value!= _password.text) {
                              return "Password does not match";
                            } else {
                              cp = true;
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.0,
                                color: Colors.black
                              ),
        
                            ),
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
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else if (n && em && p && cp) {
                                    _email.clear();
                                    _name.clear();
                                    _password.clear();
                                    _confirmPassword.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please verify your email.'),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.yellow,
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: Colors.black),
                              child: const Icon(Icons.check,size: 35)
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => {
                            Navigator.pushReplacement(
                                    context,
                                    ForwardPageRoute(child: Login()))
                          },
                          child: const Text(
                            'Already a User?',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                              color: Colors.black,                             
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
