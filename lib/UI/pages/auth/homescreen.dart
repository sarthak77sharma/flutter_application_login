import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../composition_root.dart';

class Home extends StatefulWidget {
  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MENU'),
        backgroundColor: Theme.of(context).accentColor,
        leading: IconButton(
          icon: Icon(
            Icons.logout,
            size: 36,
          ),
          onPressed: () {
            _logout(context);
          },
        ),
      ),
      body: Center(
        child: Text(
          "Welcome!",
          style: TextStyle(
            color: Colors.black,
            fontSize: 40.0,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          fixedColor: Colors.amber,
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Search',
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(Icons.account_circle),
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }

  _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => CompositionRoot.composeAuthUi(),
        ),
        (Route<dynamic> route) => false);
  }
}
