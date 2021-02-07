import 'package:flutter/material.dart';
import 'package:donence_app/models/book.dart';
import 'package:image_picker/image_picker.dart';

class AddBookPage extends StatefulWidget {
  final Book book;
  AddBookPage({this.book});
  @override
  _AddBookPageState createState() => _AddBookPageState(nBook: book);
}

class _AddBookPageState extends State<AddBookPage> {
  final Book nBook;
  final _formKey = GlobalKey<FormState>();
  String _title;
  String _thumbnail;
  String _author;
  String _description;
  int _page;
  String _isbn13;
  String _publisher;
  String _publish_date;
  String _comment;

  final picker = ImagePicker();

  _AddBookPageState({this.nBook});

  Future<void> _getImage(ImageSource imageSource) async {
    var imageFile = await picker.getImage(source: imageSource);
    if (imageFile == null) return;
    setState(
      () {
        _thumbnail = imageFile.path;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
        centerTitle: true,
      ),
      body: _bookForm(),
      bottomNavigationBar: _formSaveButton(context),
    );
  }

  Widget _bookForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _imageFormField(_thumbnail, 'Cover (optional)'),
              TextFormField(
                initialValue: nBook == null ? '' : nBook.title,
                decoration: InputDecoration(
                  labelText: 'Title*',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Title';
                  }
                  return null;
                },
                onSaved: (val) {
                  _title = val;
                },
              ),
              TextFormField(
                initialValue: nBook == null ? '' : nBook.author,
                decoration: InputDecoration(
                  labelText: 'Author*',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Author';
                  }
                  return null;
                },
                onSaved: (val) {
                  _author = val;
                },
              ),
              TextFormField(
                initialValue: nBook == null ? '' : nBook.isbn13,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'ISBN',
                ),
                validator: (value) {
                  if (value.isNotEmpty &&
                      (value.length != 13 && value.length != 10)) {
                    return 'Invalid ISBN';
                  }
                  return null;
                },
                onSaved: (val) {
                  _isbn13 = val;
                },
              ),
              TextFormField(
                initialValue: nBook == null ? '' : nBook.page.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Page',
                ),
                onSaved: (val) {
                  _page = int.parse(val);
                },
              ),
              TextFormField(
                initialValue: nBook == null ? '' : nBook.publisher,
                decoration: InputDecoration(
                  labelText: 'Publisher',
                ),
                onSaved: (val) {
                  _publisher = val;
                },
              ),
              TextFormField(
                initialValue: nBook == null ? '' : nBook.publish_date,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Publish Year',
                ),
                onSaved: (val) {
                  _publish_date = val;
                },
              ),
              TextFormField(
                minLines: 2,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Comment',
                  icon: Icon(Icons.comment),
                ),
                onSaved: (val) {
                  _comment = val;
                },
              ),
              Padding(padding: EdgeInsets.all(16)),
            ],
          ),
        ),
      ),
    );
  }

  void onCoverPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.blueGrey,
            height: 120,
            child: Container(
              child: _buildCameraMenu(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  Column _buildCameraMenu() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.image),
          title: Text('Select from gallery'),
          onTap: () => _getImage(ImageSource.gallery),
        ),
        ListTile(
          leading: Icon(Icons.camera_alt),
          title: Text('Take a picture'),
          onTap: () => _getImage(ImageSource.camera),
        ),
      ],
    );
  }

  Widget _formSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            print(
                'BOOK => ${Book(_title, _thumbnail, _author, _description, _page, _isbn13, _publisher, _publish_date).toMap()}');
            print('COMMENT => $_comment');

            //TODO: store book to database

            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'SAVE',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _placeHolder(double width, double height) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      child: Icon(Icons.add_photo_alternate_outlined),
      decoration: BoxDecoration(
        border: Border.all(width: 1, style: BorderStyle.solid),
      ),
    );
  }

  Widget _imageFormField(String image, String title) {
    var _width = MediaQuery.of(context).size.width / 10;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            child: image == null
                ? _placeHolder(_width * 3, _width * 4)
                : Image.asset(
                    image,
                    width: _width * 3,
                  ),
          ),
          Expanded(
            child: ListTile(
              trailing: Icon(Icons.arrow_drop_down),
              title: Text(title),
              onTap: () {
                onCoverPressed();
              },
            ),
          ),
        ],
      ),
    );
  }
}
