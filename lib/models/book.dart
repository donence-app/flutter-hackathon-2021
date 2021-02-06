class Book{
  final String _title;
  final String _thumbnail;
  final String _author;
  final String _description;
  final int _page;
  final String _isbn13;
  final String _publisher;
  final String _publish_date;

  Book(this._title, this._thumbnail, this._author, this._description, this._page, this._isbn13, this._publisher, this._publish_date);

  String get title => _title;
  String get thumbnail => _thumbnail;
  String get author => _author;
  String get description => _description;
  int get page => _page;
  String get isbn13 => _isbn13;
  String get publisher => _publisher;
  String get publish_date => _publish_date;
}