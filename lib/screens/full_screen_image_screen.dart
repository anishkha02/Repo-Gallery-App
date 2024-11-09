import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FullScreenImageScreen extends StatefulWidget {
  final String imageUrl;

  FullScreenImageScreen({required this.imageUrl});

  @override
  _FullScreenImageScreenState createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    checkIfBookmarked();
  }

  Future<void> checkIfBookmarked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarks') ?? [];
    setState(() {
      _isBookmarked = bookmarks.contains(widget.imageUrl);
    });
  }

  Future<void> toggleBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarks') ?? [];

    if (_isBookmarked) {
      bookmarks.remove(widget.imageUrl);
    } else {
      bookmarks.add(widget.imageUrl);
    }

    await prefs.setStringList('bookmarks', bookmarks);

    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? Colors.red : Colors.white,
            ),
            onPressed: toggleBookmark,
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: PhotoView(
        imageProvider: NetworkImage(widget.imageUrl),
        backgroundDecoration: BoxDecoration(color: Colors.black),
      ),
    );
  }
}
