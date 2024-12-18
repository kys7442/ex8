import 'package:flutter/material.dart';
import 'community_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Map<String, dynamic>> communities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCommunityData();
  }

  Future<void> fetchCommunityData() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/community'));
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
                  title: Text(community['title']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityDetailPage(
                          title: community['title'],
                          content: community['content'],
                          author: community['author'],
                          createdAt: community['created_at'],
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
