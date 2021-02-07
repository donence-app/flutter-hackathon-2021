import 'package:donence_app/models/book.dart';
import 'package:donence_app/services/database_service.dart';
import 'package:donence_app/widget/book_list_tile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BooksPage extends StatefulWidget {
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final ref = DatabaseService.allBooksReference();

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
                    onPressed: () => tapTheBook(listBook[index].title,listBook[index]),
                  );
                },
              );
            }
          }
      ),
    );
  }

  void tapTheBook(String title, Book book) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "What would you like to do?",
      buttons: [
        DialogButton(
          child: Text(
            "Delete from Books",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(233, 150, 122, 1.0),
            Color.fromRGBO(139, 0, 0, 1.0)
          ]),
          onPressed: () {
            final snackBar = SnackBar(content: Text('The book has been successfully deleted.'));

            DatabaseService.deleteBooks(FirebaseAuth.instance.currentUser.uid, title);
            DatabaseService.deleteAllBooks(FirebaseAuth.instance.currentUser.displayName, title);
            Navigator.pop(context);
            Scaffold.of(context).showSnackBar(snackBar);
          },
        ),
        DialogButton(
          child: Text(
            "Add to Donationlist",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(70, 130, 180, 1.0),
            Color.fromRGBO(95, 158, 160, 1.0)
          ]),
          onPressed: () {
            final snackBar = SnackBar(content: Text('The book has been successfully added to Donationlist.'));

            addToDonationlist(book);
            addToAllDonationlist(book);
            Navigator.pop(context);
            Scaffold.of(context).showSnackBar(snackBar);
          },
        )
      ],
    ).show();
  }

  void addToDonationlist(Book book) async {
    await DatabaseService.setDonationlist(
        FirebaseAuth.instance.currentUser.uid, book.title, book.toMap());
  }

  void addToAllDonationlist(Book book) async {
    await DatabaseService.setAllDonationlist(
        FirebaseAuth.instance.currentUser.displayName,
        book.title,
        book.toMap());
  }
}
