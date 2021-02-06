import 'package:donence_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';

class ExchangeBooksPage extends StatefulWidget {
  final User currentUser;

  ExchangeBooksPage(this.currentUser);

  @override
  _ExchangeBooksPageState createState() => _ExchangeBooksPageState();
}

class _ExchangeBooksPageState extends State<ExchangeBooksPage> {
  String position = '';

  void _showMessage(String msg) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage('Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      _showMessage(
          'Location permissions are permanently denied, we cannot request permissions.');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _showMessage(
            'Location permissions are denied (actual value: $permission)');
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

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      body: Column(
        children: [
          Center(
            child: FlatButton(
              child: Text("CHECK"),
              onPressed: () {
                _determinePosition().then((value) {
                  print(value);
                  setState(() {
                    Position p = value;
                    if (p != null) addPosToDB(p);
                    position = p.toString();
                  });
                });
              },
            ),
          ),
          Text('Position: ${position}'),
        ],
      ),
    ));
  }
}
