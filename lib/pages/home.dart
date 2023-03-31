import 'package:etourdiary/pages/download.dart';
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
  int _selectedIndex = 0;

  List<Widget> pages = [MyStatefulWidget(), View(), Download()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      title: Home._title,
      home: Scaffold(
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
