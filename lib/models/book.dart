class Book{
  final String _title;
  final String _thumbnail;
  final String _author;
  final String _description;
  final int _page;

  Book(this._title, this._thumbnail, this._author, this._description, this._page);

  String get title => _title;
  String get thumbnail => _thumbnail;
  String get author => _author;
  String get description => _description;
  int get page => _page;
}