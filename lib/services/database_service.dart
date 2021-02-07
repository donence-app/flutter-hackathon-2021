import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  static var ref =  FirebaseDatabase.instance.reference();

  static void setUserData(String uid, Map map) async{
    await ref.child('Users').child(uid).set(map);
  }

  static void setLocation(String uid, String longitude, String latitude) async{
    await FirebaseDatabase.instance.reference().child('Users').child(uid).child('location').child('longitude').set(longitude);
    await FirebaseDatabase.instance.reference().child('Users').child(uid).child('location').child('latitude').set(latitude);
  }

  static void setWishlist(String uid, String title, Map map) async{
    await ref.child('Users').child(uid).child('Wishlist').child(title).set(map);
  }

  static void setAllWishlist(String name, String title, Map map) async{
    await ref.child('AllWishlist').child(name).child(title).set(map);
  }

  static DatabaseReference allWishListReference(){
    return ref.child('AllWishlist');
  }
}