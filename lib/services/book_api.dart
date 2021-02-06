import 'package:dio/dio.dart';
import 'package:donence_app/models/book.dart';

class BookAPI{
  static final String urlIsbn = 'https://www.googleapis.com/books/v1/volumes?q=isbn:';
  static final String urlSearch = 'https://www.googleapis.com/books/v1/volumes?q=';
  static final String api_key = 'AIzaSyBKPrJ8ZNhvZj4WrmMAPC4at82sRkXdUN4';

  static Future<Book> getIsbnBook(String isbn) async{
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


    try{
      var volumeInfo = response.data['items'][0]['volumeInfo'];

      title = volumeInfo['title'];
      thumbnail = volumeInfo['imageLinks']['thumbnail'];
      author = volumeInfo['authors'][0];
      description = volumeInfo['description'];
      page = volumeInfo['pageCount'];
      isbn13 = volumeInfo['industryIdentifiers'][1]['identifier'];
      publisher = volumeInfo['publisher'];
      publish_date = volumeInfo['publishedDate'];

      return Book(title,thumbnail,author,description,page,isbn13,publisher,publish_date);
    } catch(e){
      print(e);
      return null;
    }
  }

  static Future<List<Book>> getSearchBooks(String search) async{
    var responseUrl = urlSearch + search + '+intitle:keyes&key=' + api_key;
    var response = await getResponse(responseUrl);

    List items = response.data['items'];

    var listBooks = <Book>[];

    var title = '';
    var thumbnail = '';
    var author = '';
    var description = '';
    var page = 0;
    var isbn13 = '';
    var publisher = '';
    var publish_date = '';

    try {
      for (var i = 0; i < items.length; ++i) {
        var volumeInfo = response.data['items'][i]['volumeInfo'];

        title = volumeInfo['title'];
        thumbnail = volumeInfo['imageLinks']['thumbnail'];
        author = volumeInfo['authors'][0];
        description = volumeInfo['description'];
        page = volumeInfo['pageCount'];
        isbn13 = volumeInfo['industryIdentifiers'][1]['identifier'];
        publisher = volumeInfo['publisher'];
        publish_date = volumeInfo['publishedDate'];

        listBooks.add(Book(title,thumbnail,author,description,page,isbn13,publisher,publish_date));
      }
      return listBooks;
    } catch(e){
      return null;
    }
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