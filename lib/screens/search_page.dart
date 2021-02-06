import 'package:donence_app/models/book.dart';
import 'package:donence_app/services/book_api.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
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
            onTap: () => print(books[index].title),
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
          TextField(
            controller: _filter,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: "Search..."),
            // onChanged: (_) {
            //   _getBooks();
            // },
            onSubmitted: (_) {
              _getBooks();
            },
          ),
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }
}
