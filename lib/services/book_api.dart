import 'package:dio/dio.dart';
import 'package:donence_app/models/book.dart';

class BookAPI{
  static final String url = 'https://www.googleapis.com/books/v1/volumes?q=isbn:';

  static Future<Book> getIsbnBook(String isbn) async{
    var responseUrl = url + isbn;
    var response = await getResponse(responseUrl);
    var title = '';
    var thumbnail = '';
    var author = '';
    var page = 0;

    try{
      var volumeInfo = response.data['items'][0]['volumeInfo'];

      title = volumeInfo['title'];
      thumbnail = volumeInfo['imageLinks']['thumbnail'];
      author = volumeInfo['authors'][0];
      page = volumeInfo['pageCount'];

      return Book(title,thumbnail,author,page);
    } catch(e){
      print(e);
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