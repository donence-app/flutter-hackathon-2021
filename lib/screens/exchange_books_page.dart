import 'package:donence_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ExchangeBooksPage extends StatefulWidget {
  final User currentUser;

  ExchangeBooksPage(this.currentUser);

  @override
  _ExchangeBooksPageState createState() => _ExchangeBooksPageState();
}

class _ExchangeBooksPageState extends State<ExchangeBooksPage> {
  String _position = '';
  String _currentAddress = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoaded = false;

  void _showMessage(var ctx, String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<Position> _determinePosition(var ctx) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage(
          ctx, 'Location services are disabled. Please enable it.');
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

      List<Placemark> placemarks = await placemarkFromCoordinates(p.latitude, p.longitude);

      Placemark place = placemarks[0];


      setState(() {
        _currentAddress =
            "${place.street}, ${place.administrativeArea}";
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

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Exchange Books'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _determinePosition(context).then((value) {
            print(value);
            setState(() {
              Position p = value;
              if (p != null) addPosToDB(p);
              isLoaded = true;
              _position = p.toString();
              _getAddressFromLatLng(p);
            });
          });
        },
        child: Icon(Icons.autorenew),
      ),
      // key: _scaffoldKey,
      body: Column(
        children: [
          Card(
            child: ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: isLoaded ? Text('${_currentAddress}') : _buildAnimatedPlaceHolder(),
            ),
          ),
        ],
      ),
    ));
  }
}
