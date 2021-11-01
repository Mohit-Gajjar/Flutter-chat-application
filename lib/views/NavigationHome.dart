import 'package:flutter/material.dart';
import 'package:simplelogin/views/Account.dart';
import 'package:simplelogin/views/ChatScreens.dart';
import 'package:simplelogin/views/Search.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({Key? key}) : super(key: key);

  @override
  _HomeNavState createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  List<Widget> _widgetOptions = <Widget>[
    ChatRoom(),
    SearchUser(),
    Account(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      bottomNavigationBar: Container(
        
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF160623),
          elevation: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.messenger), label: 'Chats'),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'People',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor:  Color(0xFF3152BD),
          unselectedItemColor: Colors.white54,
          onTap: _onItemTapped,
          
        ),
      ),
    );
  }
}
