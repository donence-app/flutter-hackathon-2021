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
    try {
      print(uid);
      await ref.child('Users').child(uid).child('Wishlist').child(title).set(
          map);
    } catch(e){
      print(e);
    }
  }

  static void deleteWishList(String uid, String title) async{
    await ref.child('Users').child(uid).child('Wishlist').child(title).remove();
  }

  static void setAllWishlist(String name, String title, Map map) async{
    await ref.child('AllWishlist').child(name).child(title).set(map);
  }

  static void deleteAllWishlist(String name, String title) async{
    await ref.child('AllWishlist').child(name).child(title).remove();
  }

  static DatabaseReference allWishListReference(){
    return ref.child('AllWishlist');
  }

  static void setAllDonationlist(String name, String title, Map map) async{
    await ref.child('AllDonationlist').child(name).child(title).set(map);
  }

  static void deleteAllDonationlist(String name, String title) async{
    await ref.child('AllDonationlist').child(name).child(title).remove();
  }

  static void deleteAllBooks(String name, String title) async{
    await ref.child('AllBooks').child(name).child(title).remove();
  }

  static DatabaseReference allDonationlistReference(){
    return ref.child('AllDonationlist');
  }

  static DatabaseReference usersReference(){
    return ref.child('Users');
  }

  static void setDonationlist(String uid, String title, Map map) async{
    await ref.child('Users').child(uid).child('Donationlist').child(title).set(map);
  }

  static void deleteDonationlist(String uid, String title) async{
    await ref.child('Users').child(uid).child('Donationlist').child(title).remove();
  }

  static DatabaseReference allBooksReference(){
    return ref.child('AllBooks');
  }

  static void setBooks(String uid, String title, Map map) async{
    await ref.child('Users').child(uid).child('Books').child(title).set(map);
  }

  static void setAllBooks(String name, String title, Map map) async{
    await ref.child('AllBooks').child(name).child(title).set(map);
  }

  static void deleteBooks(String uid, String title) async{
    await ref.child('Users').child(uid).child('Books').child(title).remove();
  }
}