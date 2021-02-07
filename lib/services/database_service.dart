import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  static var ref =  FirebaseDatabase.instance.reference();

  static void setUserData(String uid, Map map) async{
    await ref.child('Users').child(uid).set(map);
  }

  static void setWishlist(String uid, String title, Map map) async{
    await ref.child('Users').child(uid).child('Wishlist').child(title).set(map);
  }

  static void setAllWishlist(String name, String title, Map map) async{
    await ref.child('AllWishlist').child(name).child(title).set(map);
  }

  static Future<DatabaseReference> allWishListReference() async{
    return await ref.child('AllWishlist');
  }
}