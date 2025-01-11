import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;
  String _termsContent = '';
  String _privacyContent = '';

  Future<void> _fetchTerms() async {
    try {
      final response = await http.get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/terms'));
      if (response.statusCode == 200) {
        final List<dynamic> terms = json.decode(response.body);
        setState(() {
          for (var term in terms) {
            if (term['code'] == 'app_basic') {
              _termsContent = term['content'];
              print('표준약관 내용: $_termsContent');
            } else if (term['code'] == 'app_person') {
              _privacyContent = term['content'];
              print('개인정보취급방침 내용: $_privacyContent');
            }
          }
        });
      } else {
        throw Exception('Failed to load terms');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('약관을 불러오는 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTerms();
  }

  Future<void> _signUp() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String passwordConfirm = _passwordConfirmController.text;

    if (username.isEmpty) {
      _showError('아이디를 입력해주세요.');
      return;
    }
    if (password.isEmpty) {
      _showError('비밀번호를 입력해주세요.');
      return;
    }
    if (!isValidPassword(password)) {
      _showError('비밀번호는 대문자, 숫자, 특수문자를 각각 하나 이상 포함하고, 최소 6자리 이상이어야 합니다.');
      return;
    }
    if (passwordConfirm.isEmpty) {
      _showError('비밀번호 확인을 입력해주세요.');
      return;
    }
    if (name.isEmpty) {
      _showError('이름을 입력해주세요.');
      return;
    }
    if (email.isEmpty) {
      _showError('이메일을 입력해주세요.');
      return;
    }
    if (password != passwordConfirm) {
      _showError('비밀번호가 일치하지 않습니다.');
      return;
    }
    if (!_agreeToTerms || !_agreeToPrivacy) {
      _showError('모든 약관에 동의해야 합니다.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['API_BASE_URL']}/api/appSingUp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
          'name': name,
          'email': email,
        }),
      );

      if (mounted) {
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('회원가입 성공!')),
          );
          await _login(username, password);
        } else if (response.statusCode == 400) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('아이디 또는 이메일이 이미 존재합니다.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('회원가입 실패: ${response.body}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('에러 발생: $e')),
        );
      }
    }
  }

  Future<void> _login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['API_BASE_URL']}/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['token'];
        final String userId = responseData['userId'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
        await prefs.setString('userId', userId);

        Navigator.pop(context);
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: ${errorData['error']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('에러 발생: $e')),
      );
    }
  }

  bool isValidPassword(String password) {
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$',
    );
    return passwordRegExp.hasMatch(password);
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('표준약관'),
              Container(
                height: 150,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _termsContent,
                    style: TextStyle(height: 1.5),
                  ),
                ),
              ),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: _agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreeToTerms = value!;
                      });
                    },
                  ),
                  Text('동의함'),
                  Radio(
                    value: false,
                    groupValue: _agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreeToTerms = value!;
                      });
                    },
                  ),
                  Text('동의안함'),
                ],
              ),
              Text('개인정보취급방침'),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _privacyContent,
                    style: TextStyle(height: 1.5),
                  ),
                ),
              ),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: _agreeToPrivacy,
                    onChanged: (value) {
                      setState(() {
                        _agreeToPrivacy = value!;
                      });
                    },
                  ),
                  Text('동의함'),
                  Radio(
                    value: false,
                    groupValue: _agreeToPrivacy,
                    onChanged: (value) {
                      setState(() {
                        _agreeToPrivacy = value!;
                      });
                    },
                  ),
                  Text('동의안함'),
                ],
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: '아이디'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
              ),
              TextField(
                controller: _passwordConfirmController,
                decoration: InputDecoration(labelText: '비밀번호 확인'),
                obscureText: true,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: '이름'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: '이메일'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('가입하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
