// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:etourdiary/animations/customAnimation.dart';
import 'package:etourdiary/pages/auth/login.dart';
import 'package:etourdiary/pages/download.dart';
import 'package:etourdiary/pages/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'view.dart';
import 'submit.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String _title = 'Tour Diary';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  int _selectedIndex = 0;

  List<Widget> pages = [Submit(), View(), Download()];

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(SplashScreenState.KEYLOGIN, false);
    Navigator.pushReplacement(context, CustomPageRoute(child: const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Home._title,
      home: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomLeft,
        //       colors: [
        //         Color.fromRGBO(76, 80, 91, 1),
        //         Color.fromRGBO(94, 98, 108, 1)
        //       ],
        //     )),
        child: Scaffold(
          // backgroundColor: Colors.transparent,
            drawer: Drawer(
              // backgroundColor: Color(0xff4c505b),
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    currentAccountPicture: Icon(Icons.person),
                    accountEmail: Text('${_auth.currentUser?.email}'),
                    accountName: Text('${_auth.currentUser?.displayName}'),
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                    ),
                  ),
                  ListTile(
                    title: const Text('LogOut'),
                    onTap: () {
                      signOut();
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                    },
                  ),
                ],
              ),
            ),
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: const Text(Home._title),backgroundColor: Color(0xff4c505b)),
            body: DoubleBackToCloseApp(
              snackBar: const SnackBar(
                content: Text('Tap back again to Exit'),
              ),
              child: pages.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: ConvexAppBar(
              items: [
                TabItem(icon: Icons.add, title: 'Submit'),
                TabItem(icon: Icons.view_agenda, title: 'View'),
                TabItem(icon: Icons.download, title: 'Download'),
              ],
              backgroundColor: Color(0xff4c505b),
              color: Colors.white,
              height: 50,
              onTap: (index) => {
                setState(() {
                  _selectedIndex = index;
                })
              },
            )),
      ),
    );
  }
}
