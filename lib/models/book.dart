class Book {
  String title;
  String thumbnail;
  String author;
  String description;
  int page;
  String isbn13;
  String publisher;
  String publish_date;

  Book(this.title, this.thumbnail, this.author, this.description, this.page,
      this.isbn13, this.publisher, this.publish_date);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['title'] = title;
    map['thumbnail'] = thumbnail;
    map['author'] = author;
    map['description'] = description;
    map['page'] = page;
    map['isbn13'] = isbn13;
    map['publisher'] = publisher;
    map['publish_date'] = publish_date;
    return map;
  }

  Book.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    thumbnail = map['thumbnail'];
    author = map['author'];
    description = map['description'];
    page = map['page'];
    isbn13 = map['isbn13'];
    publisher = map['publisher'];
    publish_date = map['publish_date'];
  }

  String getTitleShort() {
    return (title.length < 60) ? title : (title.substring(0, 60) + '...');
  }

  @override
  bool operator ==(Object other) =>
      other is Book &&
          title == other.title &&
          author == other.author;

  @override
  int get hashCode => title.hashCode ^ author.hashCode;

  String getAuthorShort() {
    return (author.length < 40) ? author : (author.substring(0, 40) + '...');
  }

}
