import 'package:donence_app/services/book_api.dart';
import 'package:flutter/material.dart';
import 'package:donence_app/models/book.dart';

class AddBookPage extends StatefulWidget {
  final Book book;

  const AddBookPage({Key key, this.book}) : super(key: key);
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  String isbn;
  String title;
  String author;
  String publisher;
  String publish_date;
  String comment;
  bool addDonation;
  //image cover;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _bookForm(),
            _formSaveButton()
          ],
        ),
      ),
    );
  }

  Widget _bookForm(){
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'ISBN (optional)',
            ),
            validator: (value) {
              if (value.length != 13 || value.length != 10) {
                return 'ISBN number must be 13 characters';
              }
              return null;
            },
            onSaved: (val){
              isbn = val;
            },
          ),
          TextFormField(
            initialValue: title,
            decoration: InputDecoration(
              labelText: 'Title',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter Title';
              }
              return null;
            },
            onSaved: (val){
              title = val;
            },
          ),
          TextFormField(
            //initialValue: _book.title,
            decoration: InputDecoration(
              labelText: 'Author',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter Author';
              }
              return null;
            },
            onSaved: (val){
              author = val;
            },
          ),
          TextFormField(
            //initialValue: _book.title,
            decoration: InputDecoration(
              labelText: 'Publisher',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter Publisher';
              }
              return null;
            },
            onSaved: (val){
              publisher = val;
            },
          ),
          TextFormField(
            //initialValue: _book.title,
            decoration: InputDecoration(
              labelText: 'Publisher',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter Publisher';
              }
              return null;
            },
            onSaved: (val){
              publish_date = val;
            },
          ),


        ]));
  }

  Widget _bookFormField(String title, val){

  }

  Widget _formSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
            print('isbn $isbn');
            print('title $title');
            print('author $author');
            print('publisher $publisher');
            print('publishDate $publish_date');
            print('comment $comment');
            print('addDonation $addDonation');
          }
        },
        child: Text(
          'SAVE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
