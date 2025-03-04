import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Etc1Page extends StatefulWidget {
  const Etc1Page({super.key});

  @override
  _Etc1PageState createState() => _Etc1PageState();
}

class _Etc1PageState extends State<Etc1Page> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _wordcards = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchWordcards();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchWordcards() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_wordcards?page=$_currentPage'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> newWordcards = List<Map<String, dynamic>>.from(data['wordcards']);
        
        setState(() {
          _wordcards.addAll(newWordcards);
          _isLoading = false;
          _currentPage++;
          if (newWordcards.isEmpty) {
            _hasMoreData = false;
          }
        });
      } else {
        throw Exception('Failed to load wordcards');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('데이터를 불러오는 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchWordcards();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('말씀카드')),
      body: _wordcards.isEmpty && _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _wordcards.length + (_hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _wordcards.length) {
                  return Center(child: CircularProgressIndicator());
                }
                final wordcard = _wordcards[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wordcard['verse'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${wordcard['book']} ${wordcard['schapter']}:${wordcard['spage']} ~ ${wordcard['echapter']}:${wordcard['epage']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
