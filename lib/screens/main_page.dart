import 'package:flutter/material.dart';
import 'home_page.dart';
import 'bible_page.dart';
import 'hymn_page.dart';
import 'community_page.dart';
import '../widgets/main_bottom_navigation.dart';

class MainPage extends StatefulWidget {
  final int initialIndex;

  const MainPage({super.key, this.initialIndex = 0});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    HomePage(),
    BiblePage(),
    HymnPage(),
    CommunityPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages.map((page) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: page,
                );
              }).toList(),
            ),
          ),
          Container(
            color: Colors.grey[300],
            height: 50,
            child: Center(child: Text('Google Ad Placeholder')),
          ),
        ],
      ),
      bottomNavigationBar: MainPageBottomNavigationBar(selectedIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}