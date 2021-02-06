import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  static void setUserData(String uid, Map map) async{
    await FirebaseDatabase.instance.reference().child('Users').child(uid).set(map);
  }

  static void setLocation(String uid, String longitude, String latitude) async{
    await FirebaseDatabase.instance.reference().child('Users').child(uid).child('location').child('longitude').set(longitude);
    await FirebaseDatabase.instance.reference().child('Users').child(uid).child('location').child('latitude').set(latitude);
  }

  static void setWishlist(String uid, String title, Map map) async{
    await FirebaseDatabase.instance.reference().child('Users').child(uid).child('Wishlist').child(title).set(map);
  }

  static Future<DatabaseReference> allWishlistReference() async{
    return await FirebaseDatabase.instance.reference().child('allWishlist');
  }
}