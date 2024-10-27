import 'package:app/pages/dashboard/dashboard.dart';
import 'package:app/pages/settings/settings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Define the pages for each tab
  static const _pages = [
    {"title": "Home", "page": DashBoardPage()},
    {"title": "Usage", "page": Text("Usage", style: TextStyle(fontSize: 24))},
    {
      "title": "Billing Statements",
      "page": Text("Statement", style: TextStyle(fontSize: 24))
    },
    {"title": "Settings", "page": SettingsPage()}
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(_pages[_selectedIndex]['title'] as String),
        ),
        body: SingleChildScrollView(
            child: _pages[_selectedIndex]['page'] as Widget),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.signal_cellular_alt_outlined),
                label: 'Usage',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.file_present),
                label: 'Statements',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            selectedFontSize: 12.0,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ));
  }
}
