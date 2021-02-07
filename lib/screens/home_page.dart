import 'package:donence_app/provider/google_sign_in.dart';
import 'package:donence_app/screens/exchange_books_page.dart';
import 'package:donence_app/screens/library_page.dart';
import 'package:donence_app/screens/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  final User currentUser;

  HomePage(this.currentUser);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _scanBarcode;

  void startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
      //nextPage(cx, _scanBarcode);
    } on PlatformException {
      print('Not found!');
      // back(cx);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

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

  void onAddPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.blueGrey,
            height: 120,
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
          onTap: () => scanBarcodeNormal(),
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Add new book manually'),
          onTap: () => Navigator.of(context).popAndPushNamed('/add_manual'),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _appBar(),
        drawer: _drawer(),
        bottomNavigationBar: _bottomBar(),
        body: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            LibraryPage(),
            Container(),
            SearchPage(widget.currentUser),
          ],
        ),
      ),
    );
  }

  void _onTap(int value) {
    if (value == 1) {
      onAddPressed();
    } else {
      setState(() {
        _selectedIndex = value;
      });
    }
  }

  Widget _appBar() => AppBar(
        elevation: _selectedIndex == 0 ? 0 : 4,
        centerTitle: true,
        title: Text('Donence'),
        backgroundColor: Colors.purple[900],
      );

  Widget _bottomBar() => BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.book_rounded), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Search'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple[900],
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
              title: Text('Exchange Books'),
              leading: Icon(
                Icons.autorenew,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) =>
                            ExchangeBooksPage(widget.currentUser),),);
              },
            ),
            ListTile(
              title: Text('Log Out'),
              leading: Icon(
                Icons.logout,
              ),
              onTap: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
            ),
            ListTile(
              title: Text('SOME FEATURE'),
              leading: Icon(
                Icons.ac_unit,
              ),
            ),
          ],
        ),
      );
}
