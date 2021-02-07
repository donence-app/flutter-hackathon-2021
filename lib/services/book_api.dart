import 'package:dio/dio.dart';
import 'package:donence_app/models/book.dart';

class BookAPI {
  static final String urlIsbn =
      'https://www.googleapis.com/books/v1/volumes?q=isbn:';
  static final String urlSearch =
      'https://www.googleapis.com/books/v1/volumes?q=';
  static final String api_key = 'AIzaSyBeE1FxYwj1VSVJ_Nk6FfsNM4SJwVjGWYc';

  static Future<Book> getIsbnBook(String isbn) async {
    var responseUrl = urlIsbn + isbn;
    var response = await getResponse(responseUrl);

    var title = '';
    var thumbnail = '';
    var author = '';
    var description = '';
    var page = 0;
    var isbn13 = '';
    var publisher = '';
    var publish_date = '';

    try {
      var volumeInfo = response.data['items'][0]['volumeInfo'];

      title = volumeInfo['title'] ?? '';
      if (volumeInfo['imageLinks'] != null) {
        thumbnail = volumeInfo['imageLinks']['thumbnail'] ?? '';
      } else {
        thumbnail = '';
      }
      if (volumeInfo['authors'] != null) {
        author = volumeInfo['authors'][0] ?? '';
      } else {
        author = '';
      }
      description = volumeInfo['description'] ?? '';
      page = volumeInfo['pageCount'] ?? '';
      isbn13 = volumeInfo['industryIdentifiers'][1]['identifier'] ?? '';
      publisher = volumeInfo['publisher'] ?? '';
      publish_date = volumeInfo['publishedDate'] ?? '';

      return Book(title, thumbnail, author, description, page, isbn13,
          publisher, publish_date);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Book>> getSearchBooks(String search) async {
    var responseUrl = urlSearch + search + '&key=' + api_key;
    print(responseUrl);
    var response = await getResponse(responseUrl);

    List items = response.data['items'];

    var title = '';
    var thumbnail = '';
    var author = '';
    var description = '';
    var page = 0;
    var isbn13 = '';
    var publisher = '';
    var publish_date = '';

    var listBooks = <Book>[];

    for (var i = 0; i < items.length; ++i) {
      try {
        var volumeInfo = items[i]['volumeInfo'];

        title = volumeInfo['title'];
        if (volumeInfo['imageLinks'] != null &&
            volumeInfo['imageLinks']['thumbnail'] != null) {
          thumbnail = volumeInfo['imageLinks']['thumbnail'];
        }
        author = volumeInfo['authors'][0];
        description = volumeInfo['description'];
        page = volumeInfo['pageCount'];
        try {
          isbn13 = volumeInfo['industryIdentifiers'][1]['identifier'];
        } catch (f) {
          isbn13 = volumeInfo['industryIdentifiers'][0]['identifier'];
        }
        publisher = volumeInfo['publisher'] ?? '';
        publish_date = volumeInfo['publishedDate'] ?? '';
      } catch (_) {
        continue;
      }

      var x = Book(title, thumbnail, author, description, page, isbn13,
          publisher, publish_date);
      listBooks.add(x);
    }
    return listBooks;
  }

  static Future<Response> getResponse(String url) async {
    try {
      var response = await Dio().get(url);
      return response;
    } catch (e) {
      return null;
    }
  }
}
