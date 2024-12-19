import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? memberInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMemberInfo();
  }

  Future<void> _fetchMemberInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    String? userId = prefs.getString('userId');

    if (token == null || userId == null) {
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_members/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'X-Request-Source': 'app',
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          memberInfo = json.decode(response.body);
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원 정보 불러오기 실패')),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('에러 발생: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로필')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : memberInfo != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${memberInfo!['id']}',
                          style: TextStyle(fontSize: 18)),
                      Text('사용자 이름: ${memberInfo!['username']}',
                          style: TextStyle(fontSize: 18)),
                      Text('레벨: ${memberInfo!['level']}',
                          style: TextStyle(fontSize: 18)),
                      Text('역할: ${memberInfo!['role']}',
                          style: TextStyle(fontSize: 18)),
                      // 추가적인 회원 정보 출력
                    ],
                  ),
                )
              : Center(child: Text('회원 정보를 불러올 수 없습니다.')),
    );
  }
}
