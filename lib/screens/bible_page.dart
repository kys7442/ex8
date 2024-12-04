import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'first_sub_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  _BiblePageState createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  List<String> oldTestamentBooks = [];
  List<String> newTestamentBooks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBibleBooks();
  }

  Future<void> fetchBibleBooks() async {
    try {
      final response1 = await http.get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_bible?old=true'));
      final response2 = await http.get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_bible?new=true'));

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final List<dynamic> oldData = json.decode(response1.body);
        final List<dynamic> newData = json.decode(response2.body);
        setState(() {
          oldTestamentBooks = oldData.map((book) => book['book_kor'].toString()).toList();
          newTestamentBooks = newData.map((book) => book['book_kor'].toString()).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("성경"),
          bottom: TabBar(
            tabs: [
              Tab(text: '구약'),
              Tab(text: '신약'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BookGridView(books: oldTestamentBooks),
            BookGridView(books: newTestamentBooks),
          ],
        ),
      ),
    );
  }
}

class BookGridView extends StatelessWidget {
  final List<String> books;

  const BookGridView({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2 / 1,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FirstSubPage(bookName: books[index], bookId: index + 1),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  books[index],
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
