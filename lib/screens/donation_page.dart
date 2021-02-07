import 'package:donence_app/models/book.dart';
import 'package:donence_app/services/database_service.dart';
import 'package:donence_app/widget/book_list_tile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DonationPage extends StatefulWidget {
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final ref = DatabaseService.allDonationlistReference();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: ref.onValue,
          builder: (BuildContext context, snapshot) {
            if(snapshot.hasError){
              return Text('Error');
            } else if(snapshot.data == null){
              return Text('');
            } else{
              var listBook = <Book>[];

              Map data = snapshot.data.snapshot.value;
              data.forEach((key, value) {
                String name = key;
                Map val = value;

                if (FirebaseAuth.instance.currentUser.displayName == name){
                  val.forEach((key, value) {
                    String title = value['title'] ?? '';
                    String thumbnail = value['thumbnail'] ?? '';;
                    String author = value['author'] ?? '';;
                    var description = name ?? '';;
                    int page = value['page'] ?? 0;
                    String isbn13 = value['isbn13'] ?? '';;
                    String publisher = value['publisher'] ?? '';;
                    String publish_date = value['publish_date'] ?? '';;

                    var x = Book(title,thumbnail,author,description,page,isbn13,publisher,publish_date);
                    listBook.add(x);
                  });
                }
              });
              return ListView.builder(
                itemCount: listBook.length,
                itemExtent: 120,
                itemBuilder: (BuildContext context, int index) {
                  return BookListTileWidget(
                    book: listBook[index],
                    onPressed: () => tapTheBook(listBook[index].title),
                  );
                },
              );
            }
          }
      ),
    );
  }

  void tapTheBook(String title) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Do you want to delete?",
      buttons: [
        DialogButton(
          child: Text(
            "Delete from Donationlist",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(233, 150, 122, 1.0),
            Color.fromRGBO(139, 0, 0, 1.0)
          ]),
          onPressed: () {
            final snackBar = SnackBar(content: Text('The book has been successfully deleted.'));

            DatabaseService.deleteDonationlist(FirebaseAuth.instance.currentUser.uid, title);
            DatabaseService.deleteAllDonationlist(FirebaseAuth.instance.currentUser.displayName, title);
            Navigator.pop(context);
            Scaffold.of(context).showSnackBar(snackBar);
          },
        )
      ],
    ).show();
  }
}
