import 'package:flutter/material.dart';
import 'package:repo_gallery_app/screens/bookmark_screen.dart';
import 'repo_screen.dart';    
import 'gallery_screen.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    RepoScreen(),    
    GalleryScreen(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Repos' : 'Gallery'),
actions: [
  IconButton(
    icon: Icon(Icons.bookmark),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BookmarkScreen()),
      );
    },
  ),
],

      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.code),
            label: 'Repos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}
