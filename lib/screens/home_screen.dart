import 'package:flutter/material.dart';

import '../models/book.dart';
import '../data/books_data.dart';
import '../widgets/book_tile.dart';
import 'book_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  List<Book> bookList = books;

  List<String> genres = [
    'Բոլորը',
    'Վեպ',
    'Պատմություն',
    'Ֆանտաստիկա',
    'Բանաստեղծություն',
  ];

  String selectedGenre = 'Բոլորը';

  String searchText = '';

  String getGenreName(BookGenre genre) {
    if (genre == BookGenre.novel) {
      return 'Վեպ';
    } else if (genre == BookGenre.history) {
      return 'Պատմություն';
    } else if (genre == BookGenre.fantasy) {
      return 'Ֆանտաստիկա';
    } else {
      return 'Բանաստեղծություն';
    }
  }

  List<Book> get filteredBooks {
    return bookList.where((book) {
      bool search =
          book.title.toLowerCase().contains(searchText.toLowerCase()) ||
          book.author.toLowerCase().contains(searchText.toLowerCase());

      bool genre =
          selectedGenre == 'Բոլորը' ||
          getGenreName(book.genre) == selectedGenre;

      return search && genre;
    }).toList();
  }

  int get readCount {
    return bookList.where((book) => book.isRead).length;
  }

  void openDetails(Book book) async {
    int? result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BookDetailsScreen(book: book);
        },
      ),
    );

    if (result != null) {
      setState(() {
        book.rating = result;
        book.isRead = true;
      });
    }
  }

  void deleteBook(Book book) {
    int index = bookList.indexOf(book);

    setState(() {
      bookList.remove(book);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${book.title} գիրքը ջնջվեց'),
        action: SnackBarAction(
          label: 'Վերադարձնել',
          onPressed: () {
            setState(() {
              bookList.insert(index, book);
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Գրադարան ($readCount/${bookList.length})'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Որոնել գիրք կամ հեղինակ...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    searchController.clear();

                    setState(() {
                      searchText = '';
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (String genre in genres)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(genre),
                      selected: selectedGenre == genre,
                      onSelected: (value) {
                        setState(() {
                          selectedGenre = genre;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: filteredBooks.isEmpty
                ? const Center(
                    child: Text(
                      'Գիրք չի գտնվել',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredBooks.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 5);
                    },
                    itemBuilder: (context, index) {
                      Book book = filteredBooks[index];

                      return Dismissible(
                        key: ValueKey(book.id),

                        direction: DismissDirection.horizontal,

                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),

                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),

                        onDismissed: (direction) {
                          deleteBook(book);
                        },

                        child: BookTile(
                          book: book,

                          onTap: () {
                            openDetails(book);
                          },

                          onChanged: (value) {
                            setState(() {
                              book.isRead = value ?? false;
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
