import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool isLoggedIn = false;
  String? username;
  String? email;
  String? role;
  int? userId;
  int? level;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getString('authToken') != null;
      userId = prefs.getInt('userId');
      username = prefs.getString('username');
      email = prefs.getString('email');
      role = prefs.getString('role');
      level = prefs.getInt('level');
    });

    if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            onLoginSuccess: () {
              setState(() {
                checkLoginStatus(); // 로그인 성공 후 상태 갱신
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로필')),
      body: Center(
        child: isLoggedIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('사용자 ID: $userId'),
                  Text('사용자 이름: $username'),
                  Text('이메일: $email'),
                  Text('역할: $role'),
                  Text('레벨: $level'),
                ],
              )
            : CircularProgressIndicator(), // 로그인 상태에 따라 표시
      ),
    );
  }
}
