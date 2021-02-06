import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  static void setUserData(String uid, Map map) async{
    await FirebaseDatabase.instance.reference().child('Users').child(uid).set(map);
  }
}