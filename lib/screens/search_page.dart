import 'package:donence_app/models/book.dart';
import 'package:donence_app/services/book_api.dart';
import 'package:donence_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SearchPage extends StatefulWidget {
  final User currentUser;

  SearchPage(this.currentUser);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Book> books = [];
  final TextEditingController _filter = TextEditingController();

  void _getBooks() async {
    print(_filter.text);
    await BookAPI.getSearchBooks(_filter.text).then((value) {
      if (value == null) return;
      print(value);
      setState(() {
        books = value;
      });
    });
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: (books == null) ? 0 : books.length,
      itemExtent: 150,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            leading: Image.network(
              books[index].thumbnail,
              fit: BoxFit.fitHeight,
            ),
            title: Text(books[index].title),
            subtitle: Text(books[index].author),
            onTap: () => tapTheBook(index),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _filter,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search...",
                border: OutlineInputBorder(),
              ),
              // onChanged: (_) {
              //   _getBooks();
              // },
              onSubmitted: (_) {
                _getBooks();
              },
            ),
          ),
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }

  void tapTheBook(int index){
    Alert(
      context: context,
      content: Column(
        children: [
          Text('Author: ' + books[index].author,style: TextStyle(fontSize: 13.5),),
          SizedBox(height: 15,),
          Image.network(
            books[index].thumbnail,
            height: 120,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(height: 10,),
          books[index].description != null ? Text('Description: ' + books[index].description,style: TextStyle(fontSize: 13.5),) : SizedBox(),
        ],
      ),
      title: books[index].title,
      buttons: [

        DialogButton(
          child: Text(
            'Add to Wishlist',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            addToWishlist(books[index]);
            addToAllWishlist(books[index]);
            Navigator.pop(context);
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  void addToWishlist(Book book) async{
    await DatabaseService.setWishlist(widget.currentUser.uid, book.title, book.toMap());
  }

  void addToAllWishlist(Book book) async{
    await DatabaseService.setAllWishlist(widget.currentUser.displayName, book.title, book.toMap());
  }

}
