import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:search_widget/search_widget.dart';

class Book {
  final String name;

  Book(this.name);
}

class SearchPage extends StatefulWidget {
  final TextEditingController _filter = TextEditingController();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Book> books = []; // names we get from API

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SearchWidget<Book>(
        dataList: books,
        hideSearchBoxWhenItemSelected: false,
        listContainerHeight: MediaQuery.of(context).size.height / 4,
        queryBuilder: (String query, List<Book> list) {
          return list.where((Book item) => item.name.toLowerCase().contains(query.toLowerCase())) .toList();
        },
        // TODO: fix here
        popupListItemBuilder: (Book item) {
          return Text('${item}');
        },
        // TODO: fix here
        selectedItemBuilder:
            (Book selectedItem, VoidCallback deleteSelectedItem) {
          return Text('${selectedItem}');
        },
        // // widget customization
        // noItemsFoundWidget: NoItemsFound(),
        // textFieldBuilder:
        //     (TextEditingController controller, FocusNode focusNode) {
        //   return MyTextField(controller, focusNode);
        // },
      ),
    );
  }
}
