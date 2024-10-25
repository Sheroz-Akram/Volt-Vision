import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Define the pages for each tab
  static const List<Widget> _pages = <Widget>[
    Center(child: Text("Home", style: TextStyle(fontSize: 24))),
    Center(child: Text("Usage", style: TextStyle(fontSize: 24))),
    Center(child: Text("Statements", style: TextStyle(fontSize: 24))),
    Center(child: Text("Settings", style: TextStyle(fontSize: 24))),
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
          title: const Text("Home Page"),
        ),
        body: _pages[_selectedIndex],
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
