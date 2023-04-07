import 'package:etourdiary/pages/auth/login.dart';
import 'package:etourdiary/pages/download.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'view.dart';
import 'submit.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String _title = 'Tour Diary';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  int _selectedIndex = 0;

  List<Widget> pages = [MyStatefulWidget(), View(), Download()];

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      title: Home._title,
      home: Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountEmail: Text('${_auth.currentUser?.email}'),
                accountName: Text('${_auth.currentUser?.displayName}'),
                decoration: BoxDecoration(
                  color: Colors.black45,
                ),
              ),
              ListTile(
                title: const Text('LogOut'),
                tileColor: Colors.grey,
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
        appBar: AppBar(title: const Text(Home._title)),
        body: pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.add_circle),
              label: "Submit",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.view_agenda), label: "View"),
            BottomNavigationBarItem(
                icon: Icon(Icons.download), label: "Download")
          ],
          currentIndex: _selectedIndex,
          onTap: (index) => {
            setState(
              () {
                _selectedIndex = index;
              },
            )
          },
        ),
      ),
    );
  }
}
