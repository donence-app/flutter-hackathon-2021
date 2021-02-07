import 'package:donence_app/models/book.dart';
import 'package:donence_app/services/database_service.dart';
import 'package:donence_app/widget/book_list_tile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ExchangeBooksPage extends StatefulWidget {
  final User currentUser;
  final double MAX_PERIMETER =
      100000; //FIXME: intentional high perimeter for debug

  ExchangeBooksPage(this.currentUser);

  @override
  _ExchangeBooksPageState createState() => _ExchangeBooksPageState();
}

class _ExchangeBooksPageState extends State<ExchangeBooksPage> {
  Position _position;
  String _currentAddress = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoaded = false;
  final usersRef = DatabaseService.usersReference();

  @override
  @protected
  void initState() {
    _getLocation();
    super.initState();
  }

  Map _getUsersInPerimeter(double perimeter, AsyncSnapshot snapshot) {
    var userUids = Map();
    // Map userUids = <String,List<Book>>;
    Map data = snapshot.data.snapshot.value;
    data.forEach((key, value) {
      String uid = key;
      Map val = value;
      if (val['location'] != null) {
        var longitude = double.parse(val['location']['longitude']);
        var latitude = double.parse(val['location']['latitude']);
        var distance = Geolocator.distanceBetween(
            _position.latitude, _position.longitude, latitude, longitude);
        if (distance <= perimeter) {
          var listBook = <Book>[];
          Map data2 = snapshot.data.snapshot.value;
          Map data = data2[uid]['Donationlist'];
          if (data != null) {
            data.forEach((key, value) {
              String name = key;
              String title = value['title'] ?? '';
              String thumbnail = value['thumbnail'] ?? '';
              String author = value['author'] ?? '';
              String description = name ?? '';
              int page = value['page'] ?? 0;
              String isbn13 = value['isbn13'] ?? '';
              String publisher = value['publisher'] ?? '';
              String publish_date = value['publish_date'] ?? '';

              var x = Book(title, thumbnail, author, description, page, isbn13,
                  publisher, publish_date);
              listBook.add(x);
            });
            userUids[uid] = listBook;
          }
        }
      }
    });

    return userUids;
  }

  void _showMessage(var ctx, String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<Position> _determinePosition(var ctx) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage(ctx, 'Location services are disabled. Please enable it.');
      return await Geolocator.getLastKnownPosition();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      _showMessage(ctx,
          'Location permissions are permanently denied, we cannot request permissions.');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _showMessage(
            ctx, 'Location permissions are denied (actual value: $permission)');
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void addPosToDB(Position p) async {
    await DatabaseService.setLocation(
        widget.currentUser.uid, p.longitude.toString(), p.latitude.toString());
  }

  void _getAddressFromLatLng(Position p) async {
    try {
      var placemarks = await placemarkFromCoordinates(p.latitude, p.longitude);

      var place = placemarks[0];

      setState(() {
        _currentAddress = "${place.street}, ${place.administrativeArea}";
      });
    } catch (e) {
      print(e);
    }
  }

  _buildAnimatedPlaceHolder() {
    return Container(
      width: 300,
      child: PlaceholderLines(
        count: 1,
        animate: true,
        color: Colors.purple[200],
      ),
    );
  }

  Widget _buildUserDonationListWidget(String uid, List<Book> books) {
    return Container(
      child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (BuildContext context, int index) {
            return BookListTileWidget(
              book: books[index],
              onPressed: () {},
            );
          }),
    );
  }

  Widget _buildExchangeList() {
    return !isLoaded
        ? Transform.scale(
            scale: 0.2, child: FittedBox(child: CircularProgressIndicator()))
        : Container(
            child: StreamBuilder(
              stream: usersRef.onValue,
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error');
                } else if (snapshot.data == null) {
                  return Text('');
                } else {
                  var userDonationMap =
                      _getUsersInPerimeter(widget.MAX_PERIMETER, snapshot);

                  var listAll = [];
                  userDonationMap.forEach((key, value) {
                    // listAll.add("+ " + key);
                    List<Book> l = value;
                    listAll.addAll(l);
                  });

                  return ListView.builder(
                      itemCount: listAll.length,
                      itemBuilder: (BuildContext context, int index) {
                        return BookListTileWidget(book: listAll[index]);
                      });
                }
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Exchange Books'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _getLocation(),
        child: Icon(Icons.autorenew),
      ),
      // key: _scaffoldKey,
      body: Column(
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: isLoaded
                  ? Text('${_currentAddress}')
                  : _buildAnimatedPlaceHolder(),
            ),
          ),
          Expanded(child: _buildExchangeList()),
        ],
      ),
    ));
  }

  void _getLocation() async {
    await _determinePosition(context).then((value) {
      print(value);
      setState(() {
        Position p = value;
        if (p != null) addPosToDB(p);
        isLoaded = true;
        _position = p;
        _getAddressFromLatLng(p);
      });
    });
  }
}
