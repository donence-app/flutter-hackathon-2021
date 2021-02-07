import 'package:donence_app/models/book.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
            leading: Image.network(
              book.thumbnail,
              fit: BoxFit.fitHeight,
            ),
            title: Text(book.getTitleShort()),
            subtitle: Text(book.author),
            onTap: onPressed,
          ),
        ),
      ),
    );
  }
}
