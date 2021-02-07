import 'package:donence_app/models/book.dart';
import 'package:donence_app/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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

    /*ref.once().then((DataSnapshot snapshot){
      Map data = snapshot.value;
      data.forEach((key, value) {
        print(key);
        print(value);
      });
    });*/
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

              var listBook = <Book>[];

              Map data = snapshot.data.snapshot.value;
              data.forEach((key, value) {
                String name = key;
                Map val = value;

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
              });
              return ListView.builder(
                itemCount: listBook.length,
                itemExtent: 120,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border(right: BorderSide(color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0), width: 5))
                      ),
                      child: Center(
                        child: ListTile(
                          leading: Image.network(
                            listBook[index].thumbnail,
                            fit: BoxFit.fitHeight,
                          ),
                          title: Text(listBook[index].title),
                          subtitle: Text(listBook[index].description),
                          onTap: () => {},
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        ),
    );
  }
}
