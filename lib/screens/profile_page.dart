import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _loadMemberInfo();
  }

  Future<void> _loadMemberInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? username = prefs.getString('username');
    int? level = prefs.getInt('level');
    String? role = prefs.getString('role');
    String? email = prefs.getString('email');

    setState(() {
      memberInfo = {
        'id': userId,
        'username': username,
        'level': level,
        'role': role,
        'email': email,
      };
      isLoading = false;
    });
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
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Icon(Icons.person, size: 40),
                            title: Text(
                              '사용자 정보',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text('ID'),
                            subtitle: Text('${memberInfo!['id']}'),
                          ),
                          Divider(),
                          ListTile(
                            title: Text('사용자 이름'),
                            subtitle: Text('${memberInfo!['username']}'),
                          ),
                          Divider(),
                          ListTile(
                            title: Text('레벨'),
                            subtitle: Text('${memberInfo!['level']}'),
                          ),
                          Divider(),
                          ListTile(
                            title: Text('역할'),
                            subtitle: Text('${memberInfo!['role']}'),
                          ),
                          Divider(),
                          ListTile(
                            title: Text('이메일'),
                            subtitle: Text('${memberInfo!['email']}'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(child: Text('회원 정보를 불러올 수 없습니다.')),
    );
  }
}
