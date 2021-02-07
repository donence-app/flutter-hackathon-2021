import 'package:donence_app/models/book.dart';
import 'package:flutter/material.dart';

import 'package:random_color/random_color.dart';

class BookListTileWidget extends StatelessWidget {
  final Book book;
  final Function onPressed;

  const BookListTileWidget({Key key, this.book, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(
                    color: RandomColor().randomColor(),
                    width: 5))),
        child: Center(
          child: ListTile(
            leading: book.thumbnail.startsWith('http') ? Image.network(book.thumbnail) : Image.asset(book.thumbnail),
            title: Text(book.getTitleShort()),
            subtitle: Text(book.getAuthorShort()),
            onTap: onPressed,
          ),
        ),
      ),
    );
  }
}
