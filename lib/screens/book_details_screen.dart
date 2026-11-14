import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  int rating = 0;

  @override
  void initState() {
    super.initState();
    rating = widget.book.rating;
  }

  String getGenre() {
    if (widget.book.genre == BookGenre.novel) {
      return 'Վեպ';
    } else if (widget.book.genre == BookGenre.history) {
      return 'Պատմություն';
    } else if (widget.book.genre == BookGenre.fantasy) {
      return 'Ֆանտաստիկա';
    } else {
      return 'Բանաստեղծություն';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Գրքի տվյալներ')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.book.title,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text('Հեղինակ՝ ${widget.book.author}'),

            const SizedBox(height: 10),

            Text('Ժանր՝ ${getGenre()}'),

            const SizedBox(height: 30),

            const Text('Գնահատեք գիրքը', style: TextStyle(fontSize: 20)),

            Row(
              children: [
                for (int i = 1; i <= 5; i++)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        rating = i;
                      });
                    },
                    icon: Icon(
                      i <= rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 35,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, rating);
              },
              child: const Text('Պահպանել'),
            ),
          ],
        ),
      ),
    );
  }
}
