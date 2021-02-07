import 'package:donence_app/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WishesPage extends StatefulWidget {
  @override
  _WishesPageState createState() => _WishesPageState();
}

class _WishesPageState extends State<WishesPage> {
  final ref = DatabaseService.allWishListReference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ref.once().then((DataSnapshot snapshot){
      Map data = snapshot.value;
      data.forEach((key, value) {
        print(key);
        print(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
          stream: ref.onValue,
          builder: (BuildContext context, snapshot) {
            if(snapshot.hasError){
              return Text('Error');
            } else if(snapshot.data == null){
              return Text('Data == null');
            } else{
              Map data = snapshot.data.snapshot.value;
              data.forEach((key, value) {
                print(key);
                Map val = value;
                val.forEach((key, value) {
                  print(key);
                });
              });
              return Text('123123');
            }
          }
        ),
    );
  }
}
