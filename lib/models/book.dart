enum BookGenre { novel, history, fantasy, poetry }

class Book {
  int id;
  String title;
  String author;
  BookGenre genre;
  bool isRead;
  int rating;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    this.isRead = false,
    this.rating = 0,
  });
}
