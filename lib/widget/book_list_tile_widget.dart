import 'package:donence_app/models/book.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
                    color: Color( (math.Random().nextDouble() * 0xFFFFFF).toInt()) .withOpacity(1.0),
                    width: 5))),
        child: Center(
          child: ListTile(
            leading: Image.network(
              book.thumbnail,
              fit: BoxFit.fitHeight,
            ),
            title: Text(book.getTitleShort()),
            subtitle: Text(book.getAuthorShort()),
            onTap: onPressed,
          ),
        ),
      ),
    );
  }
}
