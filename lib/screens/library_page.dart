import 'package:donence_app/screens/books_page.dart';
import 'package:donence_app/screens/donation_page.dart';
import 'package:donence_app/screens/wishes_page.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: SafeArea(
            child: Container(
              height: kToolbarHeight,
              child: TabBar(
                tabs: [
                  Tab(
                    text: 'Books',
                  ),
                  Tab(
                    text: 'Wishes',
                  ),
                  Tab(
                    text: 'Donation',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            BooksPage(),
            WishesPage(),
            DonationPage(),
          ],
        ),
      ),
    );
  }
}
