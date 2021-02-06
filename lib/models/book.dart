class Book{
  final String _title;
  final String _thumbnail;
  final String _author;
  final int _page;

  Book(this._title, this._thumbnail, this._author, this._page);

  String get title => _title;
  String get thumbnail => _thumbnail;
  String get author => _author;
  int get page => _page;
}