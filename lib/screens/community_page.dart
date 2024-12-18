import 'package:flutter/material.dart';
import 'community_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  CommunityPageState createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  List<Map<String, dynamic>> communities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCommunityData();
  }

  Future<void> fetchCommunityData() async {
    try {
      final response = await http
          .get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/community'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          communities = List<Map<String, dynamic>>.from(data['communities']);
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

  String _getMaskedAuthor(String author) {
    List<String> names = author.split(' ');
    if (names.length > 2) {
      // 가운데 이름을 가립니다.
      names[1] = names[1][0] + '.'; // 예: "John D. Doe"
    }
    return names.join(' ');
  }

  String _formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return '${parsedDate.year}-${parsedDate.month}-${parsedDate.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('중보기도실')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: communities.length,
              itemBuilder: (context, index) {
                final community = communities[index];
                return ListTile(
                  title: Text(
                    '${community['title']} - ${_getMaskedAuthor(community['author'])} - ${_formatDate(community['created_at'])}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityDetailPage(
                          title: community['title'],
                          content: community['content'],
                          author: community['author'],
                          createdAt: community['created_at'],
                          communityId: community['id'],
                          // 필요한 경우 다른 데이터도 전달
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
