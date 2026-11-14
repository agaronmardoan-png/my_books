import 'package:flutter/material.dart';
import '../models/book.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final Function onTap;
  final Function(bool?) onChanged;

  const BookTile({
    super.key,
    required this.book,
    required this.onTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          onTap();
        },
        title: Text(
          book.title,
          style: TextStyle(
            decoration: book.isRead
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(book.author),
        leading: Checkbox(value: book.isRead, onChanged: onChanged),
        trailing: book.rating > 0
            ? Text('⭐ ${book.rating}/5')
            : const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
