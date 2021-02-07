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
          leading: Container(),
          backgroundColor: Color(0xff966fd6), //Colors.purple[900],
          flexibleSpace: SafeArea(
            child: Container(
              height: kToolbarHeight,
              child: TabBar(
                tabs: [
                  Tab(
                    text: 'Books',
                  ),
                  Tab(
                    text: 'Wishlist',
                  ),
                  Tab(
                    text: 'Donationlist',
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
