import 'package:flutter/material.dart';
import 'package:donence_app/models/book.dart';
import 'package:image_picker/image_picker.dart';

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
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

  _getImage(ImageSource imageSource) async {
    PickedFile imageFile = await picker.getImage(source: imageSource);
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
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
                decoration: InputDecoration(
                  labelText: 'Author',
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
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'ISBN',
                ),
                validator: (value) {
                  if (value.length != 13 && value.length != 10) {
                    return 'Invalid ISBN';
                  }
                  return null;
                },
                onSaved: (val) {
                  _isbn13 = val;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Page',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Page';
                  }
                  return null;
                },
                onSaved: (val) {
                  _page = int.parse(val);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Publisher',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Publisher';
                  }
                  return null;
                },
                onSaved: (val) {
                  _publisher = val;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Publish Year',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Publish Year';
                  }
                  return null;
                },
                onSaved: (val) {
                  _publish_date = val;
                },
              ),
              TextFormField(
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Comment',
                  icon: Icon(Icons.comment),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Comment';
                  }
                  return null;
                },
                onSaved: (val) {
                  _comment = val;
                },
              ),
              Padding(padding: EdgeInsets.all(16)),
              Row(
                children: [
                  SizedBox(
                    child:
                        Image.asset(_thumbnail ?? 'assets/images/placeholder.png'),
                    width: MediaQuery.of(context).size.width / 5,
                  ),
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.add_photo_alternate_outlined),
                      trailing: Icon(Icons.arrow_drop_down),
                      title: Text('Cover (optional)'),
                      onTap: () {
                        onCoverPressed();
                      },
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(10)),
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
}
