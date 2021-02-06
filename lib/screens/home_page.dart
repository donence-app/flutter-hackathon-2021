import 'package:donence_app/provider/google_sign_in.dart';
import 'package:donence_app/screens/library_page.dart';
import 'package:donence_app/screens/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  void onAddPressed(){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 180,
            child: Container(
              child: _buildAddMenu(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  Column _buildAddMenu() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.qr_code),
          title: Text('Scan book ISBN'),
          onTap: () => Navigator.of(context).pushNamed('/add_isbn'),
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Add new book manually'),
          onTap: () => Navigator.of(context).pushNamed('/add_manual'),
        ),
      ],
    );
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
    if(value == 1){
      onAddPressed();
    }else{
      setState(() {
        _selectedIndex = value;
      });
    }
  }

  Widget _appBar() => AppBar(
        elevation: _selectedIndex == 0 ? 0 : 4,
        title: Text("Donence"),
      );

  Widget _bottomBar() => BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.book_rounded), label: "Library"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Add"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Search"),
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
            ListTile(
              title: Text("SOME FEATURE"),
              leading: Icon(
                Icons.ac_unit,
              ),
            ),
            ListTile(
              title: Text("Log Out"),
              leading: Icon(
                Icons.logout,
              ),
              onTap: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
            ),
          ],
        ),
      );
}
