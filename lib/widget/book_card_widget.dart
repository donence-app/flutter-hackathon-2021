import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

Widget BookCard(listBook){
  return Card(
    child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
        border: Border(right: BorderSide(color: RandomColor().randomColor(), width: 5))
      ),
      child: Center(
        child: ListTile(
          leading: Image.network(
            listBook.thumbnail,
            fit: BoxFit.fitHeight,
          ),
          title: Text(listBook.title),
          subtitle: Text(listBook.author),
          onTap: () => {},
        ),
      ),
    ),
  );
}