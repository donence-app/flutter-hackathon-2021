import 'package:donence_app/screens/library_page.dart';
import 'package:donence_app/screens/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser;

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you going to reading book?'),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('NO'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('YES'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _appBar(),
        drawer: _drawer(),
        bottomNavigationBar: _bottomBar(),
        body: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            LibraryPage(),
            Container(),
            SearchPage(),
          ],
        ),
      ),
    );
  }

  void _onTap(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  Widget _appBar() => AppBar(
        elevation: _selectedIndex == 0 ? 0 : 4,
        title: Text('Donence'),
      );

  Widget _bottomBar() => BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.book_rounded), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Search'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
      );

  Widget _drawer() => Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName),
              accountEmail: Text(user.email),
              currentAccountPicture:
                  CircleAvatar(backgroundImage: NetworkImage(user.photoURL)),
            ),
            ListTile(title: Text('SOME FEATURE'), leading: Icon(Icons.ac_unit,),),
          ],
        ),
      );
}
