import 'package:app/pages/dashboard/dashboard.dart';
import 'package:app/pages/settings/settings.dart';
import 'package:app/pages/statements/statements.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Define the pages for each tab
  late List _pages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pages = [
      {
        "title": "Dashboard",
        "page": DashBoardPage(
          onClick: (int index) {
            print("Hello");
            setState(() {
              _selectedIndex = index;
            });
          },
        )
      },
      {
        "title": "Usage",
        "page": const Text("Usage", style: TextStyle(fontSize: 24))
      },
      {"title": "Billing Statements", "page": const StatementPage()},
      {"title": "Settings", "page": const SettingsPage()}
    ];
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
