import 'package:etourdiary/pages/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:etourdiary/animations/customAnimation.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //auth service obj
  final FirebaseAuth auth = FirebaseAuth.instance;

  //Text Controllers
  final TextEditingController _email = TextEditingController();

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
                top: MediaQuery.of(context).size.height * 0.16,
              ),
              child: const Text(
                'Forgot\nPassword',
                style: TextStyle(
                    fontSize: 50, letterSpacing: 2.0, color: Colors.white),
              ),
            ),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.5,
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
                      const SizedBox(height: 50),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final email = _email.text.trim();
                              final userSnapshot = await FirebaseFirestore
                                  .instance
                                  .collection('users')
                                  .where('email', isEqualTo: email)
                                  .get();
                              if (userSnapshot.docs.isEmpty) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Email does not exist'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                ));
                              } else {
                                try {
                                  await auth.sendPasswordResetEmail(
                                      email: email);
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Password reset mail sent'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ));
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:Text('Password reset mail sent'),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 2)));
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(55))),
                              padding:
                                  const EdgeInsets.fromLTRB(55, 25, 55, 25),
                              backgroundColor: Colors.black),
                          child: const Text(
                            'Send Link',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )),
                      const SizedBox(height: 90),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    BackwardPageRoute(child: const Login()));
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(25),
                                  backgroundColor: Colors.black),
                              child: const Icon(Icons.arrow_back_ios)),
                          const SizedBox(width: 50),
                          const Text(
                            'Back to Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
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

  // forgotPassword({email}) async {
  //   try {
  //     await auth.sendPasswordResetEmail(email: email);
  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Reset mail send successfully'),
  //       backgroundColor: Colors.green,
  //       duration: Duration(seconds: 3),
  //     ));
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Failed to send reset email'),
  //       backgroundColor: Colors.red,
  //       duration: Duration(seconds: 3),
  //     ));
  //   }
  // }
}
