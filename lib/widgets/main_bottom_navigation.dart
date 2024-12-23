import 'package:flutter/material.dart';

class MainPageBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const MainPageBottomNavigationBar(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _buildIcon('assets/images/home.png', Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/images/bible.png', Icons.book),
          label: '성경책',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/images/hymn.png', Icons.music_note),
          label: '찬송가',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/images/prayer.png', Icons.people),
          label: '중보기도실',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart, size: 24),
          label: '쇼핑몰',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 10,
      onTap: onTap,
    );
  }

  Widget _buildIcon(String assetPath, IconData fallbackIcon) {
    return Image.asset(
      assetPath,
      width: 28,
      height: 28,
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallbackIcon, size: 24);
      },
    );
  }
}
